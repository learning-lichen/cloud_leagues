class TournamentsController < ApplicationController
  before_filter :authenticate, except: [:index, :show]
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
    if params[:tournament] && params[:tournament][:league].is_a?(Hash)
      league = 0b0
      league_flags = params[:tournament][:league] || {}
      
      league_flags.keys.each do |key|
        league = league | key.to_i if league_flags[key].to_i == 1
      end

      params[:tournament][:league] = league
    end

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
    if params[:tournament] && params[:tournament][:league].is_a?(Hash)
      league = 0b0
      league_flags = params[:tournament][:league] || {}
      
      league_flags.keys.each do |key|
        league = league | key.to_i if league_flags[key].to_i == 1
      end
      
      params[:tournament][:league] = league
    end

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
