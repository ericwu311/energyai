require 'spec_helper'

describe "Building pages" do

	subject { page }

	describe "index" do
		let(:user) { FactoryGirl.create(:user) }
    	let(:building) { FactoryGirl.create(:building, creator: user) }

	    before(:all) do
	    	32.times { FactoryGirl.create(:building, creator: user) }
	    end

	    after(:all) do
	    	Building.delete_all
	    	User.delete_all
	    end

	    before(:each) do
			sign_in user
			visit buildings_path
	    end

		it { should have_selector('title', text: 'All Buildings') }
		it { should have_selector('h1',    text: 'All Buildings') }

		describe "pagination" do
			it { should have_selector('div.pagination') }

			it "should list each building" do
				Building.paginate(page: 1).each do |building|
					page.should have_selector('li', text: building.name)
				end
			end	
		end

		describe "delete links" do

			it { should_not have_link('delete') }

			describe "as an admin user" do
				let(:admin)  { FactoryGirl.create(:admin) }
				before(:each) do
					sign_in admin
					visit buildings_path
				end

				# this shit is fucking broken,  I have to test with a separate test.
				# it { should have_link('delete', href: building_path(Building.first)) }
				# it { should have_content('delete')}
				it "should be able to delete buildings" do
					# should have_content('delete')
					expect { click_link('delete') }.to change(Building, :count).by(-1)
				end
			end

			describe "as an admin user testing existence of link" do
				let(:admin2)  { FactoryGirl.create(:admin) }
				before(:each) do
					sign_in admin2
					visit buildings_path
				end
				it { should have_link('delete', href: building_path(Building.first)) }
			end
		end
	end

	describe "Build new building page" do

		let(:user) { FactoryGirl.create(:user) }

		before do
			sign_in user
			visit build_path
		end

		let (:submit) { "Install New Building"}

		it { should have_selector('h1', text:'Setup a New Building') }
		it { should have_selector('title', text: 'New Building') }

		describe "with invalid information" do
			it "should not create a building" do
				expect { click_button submit }.not_to change(Building, :count)
			end

			describe "after submission" do
				before { click_button submit }
				it { should have_selector('title', text: 'New Building') }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name",	 with: "Example Building"
				fill_in "Address",  with: "252 Liebre CT, Sunnyvale, CA 94086"
			end

			it "should create a Building" do
				expect { click_button submit }.to change(Building, :count).by(1)
			end

			describe "after saving the building" do
				before { click_button submit }
				# this is broken since we don't have a specific unique identifier for buildings
				let(:building) { Building.find_by_address('252 Liebre CT, Sunnyvale, CA 94086') }

				it { should have_selector('title', text: building.name) }
				it { should have_selector('div.alert.alert-success', text: 'success')}
			end
		end

		describe "should always follow its creator" do
			pending (:followed_users) { should include(user) }
		end

	end
	
	describe "profile page" do

		let(:user) { FactoryGirl.create(:user) }	
		let(:building) { FactoryGirl.create(:building) }
				
		before { visit building_path(building) }

		it { should have_selector('h1',    text: building.name) }
		it { should have_selector('title', text: building.name) }
		it { should have_content(building.address) }

		it "should render the building's feed" do
    		building.feed.each do |item|
    			page.should have_selector("li##{item.id}", text: item.content)
    		end
        end
	end

	describe "edit" do

		let(:user) { FactoryGirl.create(:user) }
		let(:building) { FactoryGirl.create(:building) }
		
		before do 
			sign_in user
			visit edit_building_path(building) 
		end	

		describe "page" do
			it { should have_selector('title', text: "Configure Building") }
		end

		describe "with invalid information" do
			before do
				fill_in "Address", with: ""
				click_button "Save changes" 
			end

			it { should have_content('error') }
		end

	    describe "with valid information" do
			let(:new_name)  { "New Building" }
			let(:new_address) { "n125 building street, CA" }
			before do
				fill_in "Name",             with: new_name
				fill_in "Address",          with: new_address
				click_button "Save changes"
			end

			it { should have_selector('title', text: new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { building.reload.name.should  == new_name }
			specify { building.reload.address.should == new_address }
		end
	end

end
