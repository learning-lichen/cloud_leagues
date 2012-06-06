class TournamentsController < ApplicationController
  before_filter :authenticate, except: [:index, :show]
  load_and_authorize_resource

  def index
    @tournaments = Tournament.find :all
  end

  def show
    if current_user
      @waiting_player = current_user.waiting_players.where(tournament_id: @tournament.id).first
    end
  end
    
  def new
    @tournament = Tournament.new
    (1..3).each { |i| @tournament.map_lists.build.map_order = i }
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
      (1..3).each { |i| @tournament.map_lists.build.map_order = i } if @tournament.map_lists.empty?
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
      
      respond_to do |format|
        format.html { redirect_to tournament_path(@tournament) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: :edit }
        format.js { render json: @tournament.errors.to_json }
      end
    end
  end

  def destroy
    flash[:notice] = 'Tournament destroyed successfully.'
    @tournament.destroy
    redirect_to tournaments_path
  end
end
