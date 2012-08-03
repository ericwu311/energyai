class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
	end
	
	def new
		@user = User.new
	end

	def create
    # if signed_in?
    #   redirect_to root_path
    # else
  		@user = User.new(params[:user])
  		if @user.save
  			# Handle a sucessful save.
        # sign_in @user
  			flash[:success] = "Welcome to Energy.AI!  Get started by viewing our quick start guides!"
  			redirect_to @user
  		else
  			render 'new'
  		end
	# end
	end

end
