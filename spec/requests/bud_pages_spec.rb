require 'spec_helper'

describe "bud pages" do

	subject { page }

	describe "new" do
		before(:each) { visit new_bud_path }

		it { should have_selector 'h1',  text: 'Track New Bud' }
	  	it { should have_selector('title', text: full_title('New Bud')) }

	  	let(:submit) { "Activate New Bud" }

	  	describe "with invalid information" do
	  		it "should not create a bud" do
	  			expect { click_button submit }.not_to change(Bud, :count)
	  		end

	  		describe "after submission" do
	  			before { click_button submit }

	  			it { should have_selector('title', text: 'New Bud') }
	  			it { should have_content('error') }
	  			it { should have_content('can\'t be blank') }
	  		end
	  	end
 
 	  	describe "with valid information" do
	  		before(:each) do
	  			fill_in 'bud_uid',  		with: "Example Bud"
	  			fill_in 'bud_hardware_v',  	with: "1.0"
	  			fill_in 'bud_firmware_v',  	with: "1.0"
		    end

			it "should create a bud" do
		      	expect { click_button "Activate New Bud" }.to change(Bud, :count).by(1)
	    	end
	    end
	end

	describe "index" do
		before(:all) { 31.times { FactoryGirl.create(:bud) } }
		after(:all) { Bud.delete_all }

		before(:each) { visit buds_path }

		let(:bud) { Bud.first }

		it { should have_selector('title', text: 'All Buds') }
		it { should have_selector('h1',    text: 'All Buds') }
		it { should have_selector('a',		href: "/buds/#{bud.id}") }
		it { should have_content(bud.uid) }
		it { should have_content(bud.name) }

		describe "pagination" do
			it { should have_selector('div.pagination') }

			it "should list each bud" do
				Bud.paginate(page: 1).each do |bud|
				  page.should have_selector('tr', text: bud.name)
				end
			end
		end

		#only admin should be able to see add button
		describe "add button" do
			describe "without admin" do
				it { should_not have_content('Create Bud') }
			end

			describe "with admin" do
				let(:admin)  { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit buds_path
				end
				it { should have_content('Create Bud') }
			end
		end

		describe "heart beat" do # a circuit spec
			let(:circuit) { FactoryGirl.create(:circuit, bud: bud) }
			it { should have_content('less than a minute') }
		end
	end

	describe "show" do
		let(:bud) { FactoryGirl.create(:bud) }
		before(:each) { visit bud_path(bud) }

		it { should have_selector('h1', text: bud.uid) }
	  	it { should have_selector('title', text: bud.uid) }
		it { should have_content(bud.uid) }
	  	it { should have_content(bud.name) }
	  	it { should have_content(bud.hardware_v) }
	  	it { should have_content(bud.firmware_v) }
	  	it { should have_content(bud.active) }
	  	it { should have_content('Edit') }
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		let(:building) {FactoryGirl.create(:building, creator: user)}
		let(:bud) { FactoryGirl.create(:bud, building: building) }
		before(:each) do
			building.follow!(user)
			sign_in user
		   	visit edit_bud_path(bud)
		end

		it { should have_selector('h2', text: 'Configure Bud') }
	  	it { should have_selector('title', text: bud.name) }

	  	#should only be active for admin
	  	it { should_not have_content ('Remove Bud') }

	  	describe "without entering name" do
	  		before do
	  			fill_in 'bud_name', with: ''
	  			click_button "Update"
	  		end
	  		#activated buds should have a panel name
	  		it { should have_content('error') }
			specify { bud.reload.name.should_not == '' }
	  	end

	  	describe "with invalid information" do
	  		let(:temp) { FactoryGirl.create(:bud) }
	  		before do
	  			fill_in 'bud_name', with: ''
	  			click_button "Update"
	  		end 
	  		#shouldn't be able to re-use uid
			it { should have_content('error') }
			specify { bud.reload.uid.should_not == temp.uid }
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }
			before do
				fill_in 'bud_name',             with: new_name
				click_button "Update"
			end
			it { should have_content(new_name) }
			it { should have_selector('div.alert.alert-success') }
			specify { bud.reload.name.should == new_name }
		end

		# no longer allow deleting from edit page
		# describe "with admin delete" do

		# 	let(:admin)  { FactoryGirl.create(:admin) }
		# 	let(:submit) { "Remove Bud" }

		# 	before do
		# 		building.follow!(admin)
		# 		sign_in admin
		# 		visit edit_bud_path(bud)
		# 	end
		# 	it "should remove a bud" do
		# 		expect { click_button submit }.to change(Bud, :count).by(-1)
		# 	end
		# 	describe "after submission" do
		# 		before do
		# 			click_button submit
		# 			visit buds_path
		# 		end
		# 		it { should_not have_content(bud.name) }
		# 	end
		# end
	end
end