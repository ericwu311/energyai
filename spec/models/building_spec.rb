# == Schema Information
#
# Table name: buildings
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Building do

	before do
		@building = Building.new(name: "Example Building", address: "252 Liebre CT, Sunnyvale, CA 94086") 
	end

	subject { @building }

	it { should respond_to(:name) }
	it { should respond_to(:address) }

	it { should be_valid }

	describe "when name is not present" do
		before { @building.name = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
    	before { @building.name = "a" * 51 }
    	it { should_not be_valid }
  	end

	describe "when name is already taken for that address" do
		before do
			building_with_same_name_and_address = @building.dup
			building_with_same_name_and_address.save
		end

		it { should_not be_valid }
	end

end
