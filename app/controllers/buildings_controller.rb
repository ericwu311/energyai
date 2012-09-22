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
  		@building = current_user.buildings.new
    end

    def create
    	@building = current_user.buildings.build(params[:building])
    	if @building.save
    		# handle a successful save.
    		flash[:success] = "New building successfully created!"
            @building.follow!(@building.creator)  #building creator by default is manager
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
        @new_buds = Bud.where(id: params[:building].delete(:new_bud_ids))
        
        if @building.update_attributes(params[:building])
            #handle a successful update.
            @building.add_buds(@new_buds)
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
        @buildings= @building.follower_buildings.paginate(page: params[:page])
        render 'show_follow_building'
    end

    private
        def correct_user
            # redirect_to(@building) unless b
        end

        def admin_user
        end
end
