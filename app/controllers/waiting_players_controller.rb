class WaitingPlayersController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :tournament
  before_filter :load_resource
  authorize_resource :waiting_player

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  protected
  def load_resource
    if params[:id]
      @waiting_player = WaitingPlayer.find params[:id]
    else
      @waiting_player = @tournament.waiting_players.build params[:waiting_player], as: current_user.role
      @waiting_player.user_id = current_user.id unless @waiting_player.user_id
    end
  end
end
