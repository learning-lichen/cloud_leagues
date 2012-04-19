class MapsController < ApplicationController
  before_filter :authenticate, except: [:index, :show]
  load_and_authorize_resource
  
  def index
    @maps = Map.all
  end

  def show
  end

  def new
    @map = Map.new
  end

  def create
    @map = Map.new params[:map], as: current_user.role

    if @map.save
      redirect_to map_path(@map)
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @map.update_attributes params[:map], as: current_user.role
      flash[:notice] = 'Update was successful.'
      redirect_to map_path(@map)
    else
      render action: :edit
    end
  end

  def destroy
    if @map.map_lists.empty?
      flash[:notice] = 'Tournament destroyed successfully.'
      @map.destroy
      redirect_to maps_path
    else
      flash[:notice] = 'There are tournaments that use this map. Cannot delete.'
      redirect_to map_path(@map)
    end
  end
end
