class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  def index
    #@users = User.all  #handle pagination
    @users = User.paginate(page: params[:page])
  end
 
	def show
		@user = User.find(params[:id])
    @microalerts = @user.microalerts.paginate(page: params[:page])
	end
	
	def new
    if signed_in?      
      redirect_to root_path  
    else
  		@user = User.new
    end
	end

	def create
    if signed_in?
      redirect_to root_path
    else
  		@user = User.new(params[:user])
  		if @user.save
  			# Handle a sucessful save.
        sign_in @user
    		flash[:success] = "Welcome to Energy.AI!  Get started by viewing our quick start guides!"
  			redirect_to @user
  		else
  			render 'new'
  		end
  	end
	end

  def edit
  end

  def update
    if @user.custom_update_attributes(params[:user])
      # Handle a successful update
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_back_or @user
    else
      render 'edit'
    end
  end

  def destroy
    if current_user?(User.find(params[:id])) && current_user.admin?
      flash[:error] = "An admin can't destroy yourself"
    else 
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end

  def following
    @title = "Following" 
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers" 
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end


end
