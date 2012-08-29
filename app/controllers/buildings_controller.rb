class BuildingsController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :create, :new]
	# before_filter :correct_user, only: [:edit, :update]
	# before_filter :admin_user, only: :destroy

	def index
		@buildings = Buildings.paginate(page: params[:page])
	end

	def show
		@building =  Building.find(params[:id])
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

end
