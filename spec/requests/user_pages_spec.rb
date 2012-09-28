require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "index" do

		let(:user) { FactoryGirl.create(:user) }

		before(:all) { 30.times { FactoryGirl.create(:user) } }
		after(:all) { User.delete_all }

		before(:each) do
			sign_in user
			visit users_path
		end

		it { should have_selector('title', text: 'All users') }
		it { should have_selector('h1',    text: 'All users') }

		describe "pagination" do
			it { should have_selector('div.pagination') }

			it "should list each user" do
				User.paginate(page: 1).each do |user|
				  page.should have_selector('li', text: user.name)
				end
			end
		end

		describe "delete links" do

			it { should_not have_link('delete') }

			describe "as an admin user" do
				let(:admin)  { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit users_path
				end

				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('delete') }.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(admin)) }
			end
		end
	end

	describe "signup page" do
		before(:each) { visit signup_path }

		it { should have_selector 'h1',  text: 'Sign up' }
	  	it { should have_selector('title', text: full_title('Sign up')) }
	end

	describe "signup" do
		before(:each) { visit signup_path }

	  	let(:submit) { "Create my account" }

	  	describe "with invalid information" do
	  		it "should not create a user" do
	  			expect { click_button submit }.not_to change(User, :count)
	  		end

	  		describe "after submission" do
	  			before { click_button submit }
	  			it { should have_selector('title', text: 'Sign up') }
	  			it { should have_content('error') }
	  			it { should have_content('can\'t be blank') }
	  		end
	  	end
 
 	  	describe "with valid information" do
	  		before(:each) do
	  			fill_in 'user_name',  		with: "Example User"
	  	        fill_in 'user_email',        with: "user@example.com"
	  	        fill_in 'user_password',     with: "foobar"
	  	        fill_in "Confirmation", with: "foobar"
		    end

			it "should create a user" do
		      	expect { click_button "Create my account" }.to change(User, :count).by(1)
	    	end

	    	describe "after saving the user" do
	    		before { click_button submit }
	    		let(:user) { User.find_by_email('user@example.com') }

	    		it { should_not have_content('errors') }
				# it { should have_content("happy") }
	    		it { should have_selector('title', text: user.name) }
	    		it { should have_selector('div.alert.alert-success', text: 'Welcome to Energy.AI') }
	        	it { should have_link('Sign out', href: signout_path) }
	    	end
	  	end
  	end

  	describe "profile page" do
	  	# code to make a user variable
		let(:user) { FactoryGirl.create(:user) }

		# create a bunch of microalerts
	    let!(:m1) { FactoryGirl.create(:microalert, vocal: user, content: "foo", created_at: 1.second.ago) }
	    let!(:m2) { FactoryGirl.create(:microalert, vocal: user, content: "bar", created_at: 1.second.ago) }
        
	  	before(:each) { visit user_path(user) }

	  	it { should have_selector('h1', text: user.name) }
	  	it { should have_selector('title', text: user.name) }
	  	it { should have_content(user.email) }

	  	describe "microalerts" do
	  		#verify that microalerts show up
	  		it { should have_content(m1.content) }
	  		it { should have_content(m2.content) }

	  		#verify the number appears on top
	  		it { should have_content(user.microalerts.count) }
	  	end

	  	describe "follow/unfollow buttons" do
	  		let(:other_user) { FactoryGirl.create(:user) }
	  		before { sign_in user }

	  		describe "following a user" do
	  			before { visit user_path(other_user) }

	  			it "should increment the followed user count" do
					expect do
						click_button "Follow"
					end.to change(user.followed_users, :count).by(1)
				end

				it "should increment the other user's followers count" do
					expect do
						click_button "Follow"
					end.to change(other_user.followers, :count).by(1)
				end

				describe "toggling the button" do
					before { click_button "Follow" }
					it { should have_selector('input', value: 'Unfollow') }
				end
			end

			describe "unfollowing a user" do
				before do
					user.follow!(other_user)
					visit user_path(other_user)
				end

				it "should decrement the followed user count" do
					expect do
						click_button "Unfollow"
					end.to change(user.followed_users, :count).by(-1)
				end

				it "should decrement the other user's followers count" do
					expect do
						click_button "Unfollow"
					end.to change(other_user.followers, :count).by(-1)
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
		before do 
			sign_in user
			visit edit_user_path(user) 
		end

		describe "page" do 
			it { should have_selector('h1',  text: "Update your profile") }
			it { should have_selector('title', text: "Edit #{user.name}") }
			it { should have_link('change', href: 'http://gravatar.com/emails') }
		end

		describe "with invalid information" do
			before do 
				fill_in "Email", with: "brokern"
				fill_in "Password", with: user.password
				click_button "Save changes" 
			end

			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }
			let(:new_email) { "new@example.com" }
			before do
				fill_in "Name",             with: new_name
				fill_in "Email",            with: new_email
				fill_in "Password",         with: user.password
				fill_in "Confirmation",     with: user.password
				click_button "Save changes"
			end
			it { should have_selector('title', text: new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { user.reload.name.should == new_name }
			specify { user.reload.email.should == new_email }
		end
	end

	describe "following/followers" do
		let(:user) { FactoryGirl.create(:user) }
		let(:other_user) { FactoryGirl.create(:user) }
		let(:building) { FactoryGirl.create(:building) }

		before do
			user.follow!(other_user)
			user.follow!(building)
		end

		describe "followed users and buildings" do
			before do
				sign_in user
				visit following_user_path(user)
			end

			it { should have_selector('title', text: full_title('Following')) }
			it { should have_selector('h3', text: 'Following') }
			it { should have_link(other_user.name, href: user_path(other_user)) }
			it { should have_link(building.name, href: building_path(building)) }
		end

		describe "followers user" do
			before do
				sign_in user
				visit followers_user_path(other_user)
			end

			it { should have_selector('title', text: full_title('Followers')) }
			it { should have_selector('h3', text: 'Followers') }
			it { should have_link(user.name, href: user_path(user)) }
		end

	end

	describe "buildings page" do
		let(:user) { FactoryGirl.create(:user) }
		let(:followed_building) { FactoryGirl.create(:building) }
		let(:commissioned_building) { FactoryGirl.create(:building, creator: user) }
		let(:managed_building) { FactoryGirl.create(:building) }

		before do
			user.follow!(followed_building)
			managed_building.follow!(user)
			commissioned_building.save
		end

		describe "managed, followed, or created" do
			before do
				sign_in user
				visit buildings_user_path(user)
			end

			it { should have_selector('title', text: full_title('My Buildings')) }
			it { should have_selector('h3', text: 'following') }
			it { should have_selector('h3', text: 'commissioned') }
			it { should have_selector('h3', text: 'managing') }
			it { should have_link(followed_building.name, href: building_path(followed_building)) }
			it { should have_link(commissioned_building.name, href: building_path(commissioned_building)) }
			it { should have_link(managed_building.name, href: building_path(managed_building)) }
		end
	end

end
