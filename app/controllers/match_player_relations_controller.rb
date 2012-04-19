class MatchPlayerRelationsController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :tournament
  load_and_authorize_resource :match
  load_and_authorize_resource :match_player_relation

  def update
    if @match_player_relation.update_attributes params[:match_player_relation], as: current_user.role
      redirect_to tournament_path @tournament
    else
      flash[:notice] = 'Could not update this match player relation.'
      redirect_to tournament_path @tournament
    end
  end
end
