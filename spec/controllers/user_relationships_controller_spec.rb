require 'spec_helper'

describe UserRelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "creating a user to user relationship with Ajax" do

    it "should increment the Relationship count" do
      expect do
        xhr :post, :create, user_relationship: { followed_id: other_user.id, followed_type: other_user.class.name }
      end.should change(UserRelationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, user_relationship: { followed_id: other_user.id, followed_type: other_user.class.name }
      response.should be_success
    end
  end

  describe "destroying a user to user relationship with Ajax" do

    before { user.follow!(other_user) }
    let(:relationship) { user.relationships.find_by_followed_type_and_followed_id(other_user.class.name, other_user.id) }

    it "should decrement the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.should change(UserRelationship, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      response.should be_success
    end
  end
end