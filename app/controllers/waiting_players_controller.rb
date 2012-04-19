class WaitingPlayersController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :tournament
  before_filter :load_resource
  authorize_resource :waiting_player
  
  def create
    if @waiting_player.save
      redirect_to tournament_path(@tournament)
    else
      flash[:notice] = 'Could not join tournament.'
      redirect_to tournament_path(@tournament)
    end
  end
  
  def update
    if @waiting_player.update_attributes params[:waiting_player], as: current_user.role
      redirect_to tournament_path(@tournament)
    else
      flash[:notice] = 'Could not update this waiting player.'
      redirect_to tournament_path(@tournament)
    end
  end
  
  def destroy
    @waiting_player.destroy

    next_player = @tournament.waiting_players.where(player_accepted: false).first
    @tournament.add_player next_player unless next_player.nil? || @tournament.started?

    redirect_to tournament_path(@tournament)
  end

  protected
  def load_resource
    if params[:id]
      @waiting_player = WaitingPlayer.find params[:id]
    else
      @waiting_player = @tournament.waiting_players.build params[:waiting_player], as: current_user.role
      @waiting_player.user_id ||= current_user.id
    end
  end
end
