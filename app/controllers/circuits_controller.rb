class CircuitsController < ApplicationController
  before_filter :bud, only: [:new, :create, :destroy]

  	def new
  		@circuit = @bud.circuits.new
  	end

    def index
      @circuits = @bud.circuits
    end

  	def create
   		@circuit = @bud.circuits.new(params[:circuit])
        if @circuit.save
          # Handle a sucessful save.
          flash[:success] = "Circuit created!"
          redirect_to @bud
        end
  	end

    def destroy
      @circuit.destroy
      redirect_back_or root_path
    end
end