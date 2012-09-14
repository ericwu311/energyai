class ItemsController < ApplicationController
  before_filter :load_circuit

  	def new
  		@item = @circuit.items.new
  	end

    def index
      @items = @circuit.items
    end

    def edit
      @item = @circuit.items.find(params[:id])
    end

    def update
      @item = @circuit.items.find(params[:id])
      if @item.update_attributes(params[:item])
        # Handle a successful update
        flash[:success] = "item updated"
      else
        flash[:error] = "item update failed"
      end
      redirect_to edit_bud_path(@circuit.bud)
    end

  	def create
   		@item = @circuit.items.new(params[:item])
        if @item.save
          # Handle a sucessful save.
          flash[:success] = "item created!"
          redirect_to edit_bud_path(@circuit.bud)
        else
          render 'new'
        end
  	end

    def destroy
        #only admin has access to item deletion
      if signed_in? && current_user.admin?
        @item = @circuit.items.find(params[:id])
        @item.destroy
        flash[:success] = "item removed"
        redirect_to edit_bud_path(@circuit.bud)
      else 
        flash[:error] = "That requires admin priveleges"
      end
    end

    private
      def load_circuit
        #initialize circuit w/ ability to expand for other parents
        resource, id = request.path.split('/')[1,2]  # circuits/1
        @circuit = resource.singularize.classify.constantize.find(id)  # Circuit.find(1)
      end
end