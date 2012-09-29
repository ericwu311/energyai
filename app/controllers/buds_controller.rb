class BudsController < ApplicationController
  before_filter :correct_manager, only: :edit
  
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
      4.upto(7) { |i| @bud.circuits.create(channel: i) }
      # spi1
      32.upto(35) { |i| @bud.circuits.create(channel: i) }
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
    # current_channel = 0
    circuits = @bud.circuits.where("channel < ?", 32)
    max_circuit = circuits.max_by { |cir| cir.channel }
    current_channel = max_circuit.channel unless max_circuit.nil?
    new_channel = current_channel.nil? ? 4 : current_channel + 1  

    4.times do
      if new_channel >= 32 
        flash[:error] = "Can't add any more circuits on spi0"
      else 
        @bud.circuits.create(channel: new_channel)
        new_channel += 1
      end
    end
    redirect_to edit_bud_path(@bud)
  end

  def more_circuits_right   # adds 4 circuits to spi1
    @bud = Bud.find(params[:id])
    # current_channel = 31
    circuits = @bud.circuits.where("channel > ?", 32)
    max_circuit = circuits.max_by { |cir| cir.channel }
    current_channel = max_circuit.channel unless max_circuit.nil?
    new_channel = current_channel.nil? ? 32 : current_channel + 1
    
    4.times do
      if new_channel >= 64 then
        flash[:error] = "Can't add any more right circuits"
      else
        @bud.circuits.create(channel: new_channel)
        new_channel += 1
      end
    end
    redirect_to edit_bud_path(@bud)
  end

  private
    def correct_manager
      @bud = Bud.find(params[:id])
      redirect_to(root_path) unless @bud.managers.include?(current_user)
    end

end