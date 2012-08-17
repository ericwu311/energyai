require 'spec_helper'

describe UserUserRelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "creating a user to user relationship with Ajax" do

    it "should increment the UserUserRelationship count" do
      expect do
        xhr :post, :create, user_user_relationship: { followed_id: other_user.id }
      end.should change(UserUserRelationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, user_user_relationship: { followed_id: other_user.id }
      response.should be_success
    end
  end

  describe "destroying a user to user relationship with Ajax" do

    before { user.follow!(other_user) }
    let(:relationship) { user.user_user_relationships.find_by_followed_id(other_user) }

    it "should decrement the UserUserRelationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.should change(UserUserRelationship, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      response.should be_success
    end
  end
end