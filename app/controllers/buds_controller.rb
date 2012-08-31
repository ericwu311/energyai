class BudsController < ApplicationController
  	def new
  		@bud = Bud.new
  	end

  	def show
  		@bud = Bud.find(params[:id])
      @circuits = @bud.circuits.paginate(page: params[:page])
  	end

  	def edit
  		@bud = Bud.find(params[:id])
  	end

    def update
      @bud = Bud.find(params[:id])
      if @bud.update_attributes(params[:bud])
        # Handle a successful update
        flash[:success] = "Bud updated"
        redirect_to @bud
      else
        render 'edit'
      end
    end

  	def index
  		@buds = Bud.paginate(page: params[:page])
  	end

  	def create
   		@bud = Bud.new(params[:bud])
   		if @bud.save
     		flash[:success] = "Bud Created!"
     		redirect_to @bud
   		else
     		render 'new'
   		end
  	end

    def destroy
      if signed_in? && current_user.admin?
        Bud.find(params[:id]).destroy
        flash[:success] = "Bud destroyed."
        redirect_to root_path
      else 
        flash[:error] = "That requires admin priveleges"
      end
    end
end