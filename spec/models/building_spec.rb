# == Schema Information
#
# Table name: buildings
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  avatar     :string(255)
#

require 'spec_helper'

describe Building do

	let(:user) { FactoryGirl.create(:user) }

	before do
		@building = user.buildings.new(name: "Example Building", address: "252 Liebre CT, Sunnyvale, CA 94086") 
	end

	subject { @building }

	it { should respond_to(:name) }
	it { should respond_to(:address) }
	it { should respond_to(:creator) }
	it { should respond_to(:managers) }
	it { should respond_to(:microalerts) }
	it { should respond_to(:feed) }
	it { should respond_to(:followers) }
	it { should respond_to(:followed_users) }
	it { should respond_to(:following?) }
	it { should respond_to(:follow!) }
	it { should respond_to(:unfollow!) }
	it { should respond_to(:user_bldg_relationships) }
	it { should respond_to(:bldg_user_relationships) }

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

	describe "microalert associations" do

		before { @building.save }
		let!(:older_microalert) do
			FactoryGirl.create(:microalert, vocal: @building, created_at: 1.day.ago)
		end
		let!(:newer_microalert) do
			FactoryGirl.create(:microalert, vocal: @building, created_at: 1.hour.ago)
		end

		it "should have the right microalerts in the right order" do
			@building.microalerts.should == [newer_microalert, older_microalert]
		end

		it "should destroy associated microalerts" do
			microalerts = @building.microalerts
			@building.destroy
			microalerts.each do |microalert|
				Microalert.find_by_id(microalert.id).should be_nil
			end
		end

		describe "status" do
			let(:unfollowed_alert) do
				FactoryGirl.create(:microalert, vocal: FactoryGirl.create(:building))
			end
			let(:followed_user) { FactoryGirl.create(:user) }

			before do
				@building.follow!(followed_user)
				3.times { followed_user.microalerts.create!(content: "Lorem ipsum") }
			end

			its(:feed) { should include(newer_microalert) }
			its(:feed) { should include(older_microalert) }
			its(:feed) { should_not include(unfollowed_alert) }
			its(:feed) do
				followed_user.microalerts.each do |microalert|
				 	should include(microalert)
				end
			end
		end
	end	

	describe "user relationships" do

		let!(:other_user) do
			FactoryGirl.create(:user)
		end

		its(:creator) { should == user }

		describe "should always follow its creator" do
			its(:followed_users) { should include(user) }
		end

		describe "managers should alias followed_users" do
			its(:followed_users) { should be its(:managers) }
		end

		describe "following user" do
			its(:followers) { should include(other_user) }
		end

		describe "user sets default building" do
			before do
				other_user.default_building = @building
			end
			its(:default_users) { should include(other_user) } 
		end
	end
end
