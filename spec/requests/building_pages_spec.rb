require 'spec_helper'

describe "Building pages" do

	subject { page }

	describe "Build new building page" do
		before  { visit build_path }

		let (:submit) { "Install New Building"}

		it { should have_selector('h1', text:'Setup a New Building') }
		it { should have_selector('title', text: 'New Building') }

		describe "with invalid information" do
			it "should not create a building" do
				expect { click_button submit }.not_to change(Building, :count)
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
		end
	end
	
	describe "profile page" do
	
		let(:building) { FactoryGirl.create(:building) }
				
		before { visit building_path(building) }

		it { should have_selector('h1',    text: building.name) }
		it { should have_selector('title', text: building.name) }
	end


	describe "index" do
	
	end


end
