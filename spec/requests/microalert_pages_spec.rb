require 'spec_helper'

describe "Microalert Pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }


	describe "microalert creation" do
		before { visit new_microalert_path }

		describe "with invalid information" do
			
			it "should not create a microalert" do
				expect { click_button "Create"}.should_not change(Microalert, :count)
			end
			
			describe "error messages" do
				before { click_button "Create" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do

			before { fill_in 'microalert_content', with: "Lorem ipsum" }
			it "should create a microalert" do
				expect { click_button "Create" }.should change(Microalert, :count).by(1)
			end
		end
	end
	
	describe "microalert destruction" do
		before { FactoryGirl.create(:microalert, user: user) }

		describe "as correct user" do
			describe "from the userpath" do
				before { visit user_path(user) }
				it "should delete a microalert" do
					expect { click_link "delete" }.should change(Microalert, :count).by(-1)
				end
				
				describe "submitting to the destroy action" do
					before {  delete microalert_path(FactoryGirl.create(:microalert)) }
					pending { response.should redirect_to(user_path(user)) }
				end
			end

			describe "from the homepage" do
				before { visit root_path }
				it "should delete a microalert" do
					expect { click_link "delete" }.should change(Microalert, :count).by(-1)
				end

				describe "submitting to the destroy action" do
					before {  delete microalert_path(FactoryGirl.create(:microalert)) }
					specify { response.should redirect_to(root_path) }
				end

			end
		end

#		describe "as incorrect user" do
#			before 
	end
end
