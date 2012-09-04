class CircuitsController < ApplicationController
  before_filter :load_bud

  	def new
  		@circuit = @bud.circuits.new
  	end

    def index
      @circuits = @bud.circuits
    end

    def edit
      @circuit = @bud.circuits.find(params[:id])
    end

    def update
      @circuit = @bud.circuits.find(params[:id])
      if @circuit.update_attributes(params[:circuit])
        # Handle a successful update
        flash[:success] = "Circuit updated"
      else
        flash[:error] = "Circuit update failed"
      end
      redirect_to edit_bud_path(@bud)
    end

  	def create
   		@circuit = @bud.circuits.new(params[:circuit])
        if @circuit.save
          # Handle a sucessful save.
          flash[:success] = "Circuit created!"
          redirect_to @bud
        else
          render 'new'
        end
  	end

    def destroy
      @circuit = @bud.circuits.find(params[:id])
      @circuit.destroy
      flash[:success] = "Circuit removed"
      redirect_to edit_bud_path(@bud)
    end

    private
      def load_bud
        resource, id = request.path.split('/')[1,2]  # buds/1
        @bud = resource.singularize.classify.constantize.find(id)  # Bud.find(1)
      end
end