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
	end
	
	describe "profile page" do
	
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


	describe "index" do
	
	end


end
