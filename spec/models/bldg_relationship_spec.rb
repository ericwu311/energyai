require 'spec_helper'

describe BldgRelationship do

	let(:follower) { FactoryGirl.create(:building) }
	let(:followed_user) { FactoryGirl.create(:user) }
	let(:followed_building) { FactoryGirl.create(:building) }
	let(:user_relationship) { follower.relationships.build(followed_id: followed_user.id, followed_type: followed_user.class.name) }
	let(:bldg_relationship) { follower.relationships.build(followed_id: followed_building.id, followed_type: followed_building.class.name) }

	describe "following a User" do
		subject { user_relationship }

		it { should be_valid }

		describe "accessible attributes" do
			it "should not allow access to follower_id" do
				expect do
					BldgRelationship.new(follower_id: follower.id)
				end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
			end
		end

		describe "follower methods" do
			it { should respond_to(:follower) }
			it { should respond_to(:followed) }
			its(:follower) { should == follower }
			its(:followed) { should == followed_user }
		end

		describe "when followed id is not present" do
			before { user_relationship.followed_id = nil }
			it { should_not be_valid }
		end

		describe "when followed type is not present" do
			before { user_relationship.followed_type = nil }
			it { should_not be_valid }
		end

		describe "when follower id is not present" do
			before { user_relationship.follower_id = nil }
			it { should_not be_valid }
		end
	end

	describe "following a Building" do

		subject { bldg_relationship }

		it { should be_valid }

		describe "follower methods" do
			it { should respond_to(:follower) }
			it { should respond_to(:followed) }
			its(:follower) { should == follower }
			its(:followed) { should == followed_building }
		end

		describe "when followed id is not present" do
			before { bldg_relationship.followed_id = nil }
			it { should_not be_valid }
		end

		describe "when followed type is not present" do
			before { bldg_relationship.followed_type = nil }
			it { should_not be_valid }
		end

		describe "when follower id is not present" do
			before { bldg_relationship.follower_id = nil }
			it { should_not be_valid }
		end
	end

end
