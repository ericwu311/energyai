# == Schema Information
#
# Table name: user_user_relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe UserUserRelationship do
 	
	let(:follower) { FactoryGirl.create(:user) }
	let(:followed) { FactoryGirl.create(:user) }
	let(:user_user_relationship) { follower.user_user_relationships.build(followed_id: followed.id) }

	subject { user_user_relationship }

	it { should be_valid }

	describe "accessible attributes" do
		it "should not allow access to follower_id" do
			expect do
				UserUserRelationship.new(follower_id: follower.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "follower methods" do
		it { should respond_to(:follower) }
		it { should respond_to(:followed) }
		its(:follower) { should == follower }
		its(:followed) { should == followed }
	end

	describe "when followed id is not present" do
		before { user_user_relationship.followed_id = nil }
		it { should_not be_valid }
	end

	describe "when follower id is not present" do
		before { user_user_relationship.follower_id = nil }
		it { should_not be_valid }
	end

end
