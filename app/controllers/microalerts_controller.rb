class MicroalertsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :destroy]
  before_filter :correct_user, only: [:destroy]
	
	def new
		@microalert = current_user.microalerts.build
	end

	def index
	end

	def create

	    #if signed_in?
	    #  redirect_to root_path
	    #else
	  		@microalert = current_user.microalerts.build(params[:microalert])
	  		if @microalert.save
	  			# Handle a sucessful save.
	        	flash[:success] = "Microalert created!"
	  			redirect_to root_path
	  		else
	  			@feed_items = []
	  			render 'new'  
	  		end
		#end
	end

	def destroy
		@microalert.destroy
		redirect_back_or root_path    #broken needs to remember where it deleted from.
	end

	private

		def correct_user
			@microalert = current_user.microalerts.find_by_id(params[:id])
			redirect_to root_path if @microalert.nil?
		end

end