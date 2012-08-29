class BuildingsController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :create, :new]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy

	def index
		@buildings = Building.paginate(page: params[:page])
	end

	def show
		@building =  Building.find(params[:id])
        @feed_items = @building.microalerts.paginate(page: params[:page])
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
        
    end

    def update
    end

    def destroy
    end

    def following
    end

    def followers
    end

    private
        def correct_user
            # redirect_to(@building) unless b
        end

        def admin_user
        end
end
