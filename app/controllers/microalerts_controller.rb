class MicroalertsController < ApplicationController
	before_filter :load_vocal
	before_filter :signed_in_user, only: [:new, :create, :destroy]
	before_filter :correct_user, only: :destroy
	
	def new
		@microalert = @vocal.microalerts.new
	end

	def index
		@microalerts = @vocal.microalerts
	end

	def create

	    #if signed_in?
	    #  redirect_to root_path
	    #else
	  		@microalert = @vocal.microalerts.new(params[:microalert])
	  		if @microalert.save
	  			# Handle a sucessful save.
	        	flash[:success] = "Microalert created!"
	  			redirect_to @vocal
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

		def load_vocal
			resource, id = request.path.split('/')[1,2]  # users/1
			@vocal = resource.singularize.classify.constantize.find(id)  # User.find(1)
		end

end