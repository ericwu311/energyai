class UserRelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    if params[:user_relationship][:followed_type] == "User"
      @followed = User.find(params[:user_relationship][:followed_id])
    elsif params[:user_relationship][:followed_type] == "Building"
      @followed = Building.find(params[:user_relationship][:followed_id])
    end
    current_user.follow!(@followed)
    respond_to do |format|
      format.html { redirect_to @followed }
      format.js
    end
  end

  def destroy
    @followed = UserRelationship.find(params[:id]).followed
    current_user.unfollow!(@followed)
    respond_to do |format|
      format.html { redirect_to @followed }
      format.js
    end
  end
end