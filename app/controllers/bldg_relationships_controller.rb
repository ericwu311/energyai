class BldgRelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @building = Building.find(params[:bldg_relationship][:followed_id])
    current_user.follow!(@building)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @building = BldgRelationship.find(params[:id]).followed
    current_user.unfollow!(@building)
    respond_to do |format|
      format.html { redirect_to @building }
      format.js
    end
  end
end