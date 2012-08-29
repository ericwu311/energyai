class BudsController < ApplicationController
  	def new
  		@bud = Bud.new
  	end

  	def show
  		@bud = Bud.find(params[:id])
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
end