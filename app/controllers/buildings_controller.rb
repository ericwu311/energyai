class BuildingsController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :create, :new, :following, :followers]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy

	def index
		@buildings = Building.paginate(page: params[:page])
	end

	def show
		@building =  Building.find(params[:id])
        @feed_items = @building.feed.paginate(page: params[:page])
	end

	def new
  		@building = Building.new
    end

    def create
    	@building = Building.new(params[:building])
    	if @building.save
    		# handle a successful save.
    		flash[:success] = "New building successfully created!"
    		redirect_to @building
    	else
    		render 'new'
    	end
    end

    def edit
        @building = Building.find(params[:id])
    end

    def update
        @building = Building.find(params[:id])
        if @building.update_attributes(params[:building])
            #handle a successful update.
            flash[:success] = "Building successfully configured."
            redirect_to @building
        else
            render 'edit'
        end
    end

    def destroy
        Building.find(params[:id]).destroy
        flash[:success] = "Building demolished."
        redirect_to buildings_path
    end

    def following
        @title = "Following"
        @building = Building.find(params[:id])
        @users = @building.followed_users.paginate(page: params[:page])
        @buildings = @building.followed_buildings.paginate(page: params[:page])
        render 'show_follow_building'
    end

    def followers
        @title = "Followers"
        @building = Building.find(params[:id])
        @users = @building.followers.paginate(page: params[:page])
        @buildings= @building.followed_buildings.paginate(page: params[:page])
        render 'show_follow_building'
    end

    private
        def correct_user
            # redirect_to(@building) unless b
        end

        def admin_user
        end
end
