class BuildingsController < ApplicationController
	def show
		@building =  Building.find(params[:id])
	end

	def new
  		@building = Building.new
    end

    def create
		redirect_to @building
    end

end
