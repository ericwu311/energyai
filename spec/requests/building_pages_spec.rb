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

			it "should increase the Buildings created by user " do
				expect { click_button submit }.to change(user.buildings, :count).by(1)
			end

			it "should increase the managed buildings count" do
				expect { click_button submit }.to change(user.managed_buildings, :count).by(1)
			end				

			describe "after saving the building" do
				before { click_button submit }
				# this is broken since we don't have a specific unique identifier for buildings
				let(:building) { Building.find_by_address('252 Liebre CT, Sunnyvale, CA 94086') }

				it { should have_selector('title', text: building.name) }
				it { should have_selector('div.alert.alert-success', text: 'success')}
			end
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

        pending "should toggle just the microalerts for the building"
 
 		describe "follow/unfollow buttons" do

	  		let(:other_user) { FactoryGirl.create(:user) }
	  		let(:building) { FactoryGirl.create(:building) }

	  		before { sign_in user }

	  		describe "following a building" do
	  			before { visit building_path(building) }

	  			it "should increment the followed building count" do
					expect do
						click_button "Follow"
					end.to change(user.followed_buildings, :count).by(1)
				end

				it "should increment the building's followers count" do
					expect do
						click_button "Follow"
					end.to change(building.followers, :count).by(1)
				end

				describe "toggling the button" do
					before { click_button "Follow" }
					it { should have_selector('input', value: 'Unfollow') }
				end
			end

			describe "unfollowing a building" do

				before do
					user.follow!(building)
					visit building_path(building)
				end

				it "should decrement the followed user count" do
					expect do
						click_button "Unfollow"
					end.to change(user.followed_buildings, :count).by(-1)
				end

				it "should decrement the building's followers count" do
					expect do
						click_button "Unfollow"
					end.to change(building.followers, :count).by(-1)
				end

				describe "toggling the button" do
					before { click_button "Unfollow" }
					it { should have_selector('input', value: 'Follow') }
				end
			end
		end
	end

	describe "edit" do

		let(:user) { FactoryGirl.create(:user) }
		let(:building) { FactoryGirl.create(:building, creator: user) }
		let(:manager) { FactoryGirl.create(:user) }
		let(:bud) { FactoryGirl.create(:bud, building: building) }

		before do 
			sign_in user
			building.follow!(manager)
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

		describe "unmanage buttons" do
			it "should decrement the followed user count" do
				expect do
					click_button "Unassign"
				end.to change(building.managers, :count).by(-1)
			end

			it "should decrement the mangers' manageed buildings" do
				expect do
					click_button "Unassign"
				end.to change(manager.managed_buildings, :count).by(-1)
			end
		end

		describe "nested form for associated buds" do
			it { should have_content(bud.name) }
		end
	end

	describe "following/followers" do 
		let(:user) { FactoryGirl.create(:user) }
		let(:building) { FactoryGirl.create(:building) }
		let(:other_building) { FactoryGirl.create(:building) }

		before do
			building.follow!(other_building)
			building.follow!(user) 
		end

		describe "followed users and buildings" do
			before do
				sign_in user
				visit following_building_path(building)
			end

			it { should have_selector('title', text: full_title('Following')) }
			it { should have_selector('h3', text: 'Following') }
			it { should have_link(other_building.name, href: building_path(other_building)) }
			it { should have_link(user.name, href: user_path(user)) }
		end

		describe "followers buildings" do
			before do
				sign_in user
				visit followers_building_path(other_building)
			end

			it { should have_selector('title', text: full_title('Followers')) }
			it { should have_selector('h3', text: 'Followers') }
			it { should have_link(building.name, href: building_path(building)) }
		end
	end
end
