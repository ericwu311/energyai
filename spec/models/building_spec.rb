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
#  creator_id :integer
#

require 'spec_helper'

describe Building do

	let(:user) { FactoryGirl.create(:user) }

	before do
		@building = user.buildings.build(name: "Example Building", address: "252 Liebre CT, Sunnyvale, CA 94086") 
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
	it { should respond_to(:followed_buildings) }
	it { should respond_to(:following?) }
	it { should respond_to(:follow!) }
	it { should respond_to(:unfollow!) }
	it { should respond_to(:relationships) }
	it { should respond_to(:reverse_user_relationships) }
	it { should respond_to(:reverse_bldg_relationships) }
	it { should respond_to(:new_bud_ids) }
	it { should respond_to(:new_user_ids) }


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

		before do
			@building.save
			@building.follow!(other_user)
			other_user.follow!(@building)
		end

		its(:creator) { should == user }

		it { should be_following(other_user) }
		its(:followed_users)  { should include(other_user) }

		# describe "managers should alias followed_users" do
		# 	@building.managers.each do |manager|
		# 		its(:followed_users) { should include(manager) }
		# 	end
		# end


		describe "following user" do
			subject { other_user }
			its(:managed_buildings) { should include(@building) }
		end

		describe "user sets default building" do
			before do
				other_user.default_building=(@building)
				other_user.save
				@building.save
			end
			its(:default_users) { should include(other_user) } 
		end

		describe "and unfollowing" do
			before do
				@building.unfollow!(other_user)
			end

			it { should_not be_following(other_user) }
			its(:managers) { should_not include(other_user) }
		end

		it "should destroy associated user and building relations" do
			relationships = @building.relationships
			@building.destroy
			relationships.each do |relationship|
				BldgRelationship.find_by_id(relationship.id).should be_nil
			end
		end

		it "should destroy associated reverse_user_relationships" do
			reverse_user_relationships = @building.reverse_user_relationships
			@building.destroy
			reverse_user_relationships.each do |reverse_user_relationship|
				UserBldgRelationships.find_by_id(reverse_user_relationship.id).should be_nil
			end
		end
	end

	describe "building relationships" do

		let!(:other_building) do
			FactoryGirl.create(:building)
		end

		before do 
			@building.save
			@building.follow!(other_building)
			other_building.follow!(@building)
		end

		it { should be_following(other_building) }
		its(:followed_buildings) { should include(other_building) }

		describe "followed" do
			subject { other_building }
			its(:follower_buildings) { should include(@building) }
		end

		describe "and unfollowing" do
			before do
				@building.unfollow!(other_building)
			end

			it { should_not be_following(other_building) }
			its(:followed_buildings) { should_not include(other_building) }
		end

		it "should destroy associated reverse_building relationships" do
			reverse_bldg_relationships = @building.reverse_bldg_relationships
			@building.destroy
			reverse_bldg_relationships.each do |reverse_bldg_relationship|
				BldgRelationships.find_by_id(reverse_bldg_relationship.id).should be_nil
			end
		end
	end
end
