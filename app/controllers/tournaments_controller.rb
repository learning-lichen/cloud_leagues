class TournamentsController < ApplicationController
  before_filter :authenticate, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @tournaments = Tournament.find :all
  end

  def show
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new params[:tournament], as: current_user.role

    if @tournament.save
      redirect_to tournament_path(@tournament)
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @tournament.update_attributes params[:tournament], as: current_user.role
      flash[:notice] = 'Tournament updated successfully.'
      redirect_to tournament_path(@tournament)
    else
      render action: :edit
    end
  end

  def destroy
    flash[:notice] = 'Tournament destroyed successfully.'
    @tournament.destroy
    redirect_to tournaments_path
  end
end
