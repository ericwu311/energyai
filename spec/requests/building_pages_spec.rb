require 'spec_helper'

describe "Building pages" do

	subject { page }

	describe "Build new building page" do
		before  { visit build_path }

		it { should have_selector('h1', text:'Setup a New Building') }
		it { should have_selector('title', text: 'New Building') }
	end
	
	describe "profile page" do
		before { visit building_path(building) }

		it { should have_selector('h1',    text: building.name) }
		it { should have_selector('title', text: building.name) }
	end


	describe "index" do
	
	end


end
