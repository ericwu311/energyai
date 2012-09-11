class StaticPagesController < ApplicationController

  def home
  	if signed_in?
  		if current_user.default_building.blank?
			store_location
		end
  		@feed_items = current_user.feed.paginate(page: params[:page])
  		@user = current_user
  	end
  end

end
