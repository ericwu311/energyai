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
        # create initial circuits, spi0
        i = 3
        while i < 7 do
          @bud.circuits.create(channel: i)
          i += 1
        end
        # spi1
        i = 32
        while i < 36 do
          @bud.circuits.create(channel: i)
          i += 1
        end
        flash[:success] = "Bud Created!"
        redirect_to @bud
      else
        render 'new'
      end
    end

    def destroy
      if signed_in? && current_user.admin?
        #only admin has access to bud deletion
        Bud.find(params[:id]).destroy
        flash[:success] = "Bud destroyed."
        redirect_to root_path
      else 
        flash[:error] = "That requires admin priveleges"
      end
    end

    def more_circuits_left  # adds 4 circuits to spi0
      @bud = Bud.find(params[:id])
      i = 0
      for cir in @bud.circuits.where("channel < ?", 32) do
        i = [cir.channel, i].max
      end
      i += 1
      4.times do
        if i >= 32 then
          flash[:error] = "Can't add any more left circuits"
          break
        end
        @bud.circuits.create(channel: i)
        i += 1
      end
      redirect_to edit_bud_path(@bud)
    end

    def more_circuits_right   # adds 4 circuits to spi1
      @bud = Bud.find(params[:id])
      i = 31
      for cir in @bud.circuits.where("channel > ?", 32) do
        i = [cir.channel, i].max
      end
      i += 1
      4.times do
        if i >= 64 then
          flash[:error] = "Can't add any more right circuits"
          break
        end
        @bud.circuits.create(channel: i)
        i += 1
      end
      redirect_to edit_bud_path(@bud)
    end
end