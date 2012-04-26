class MatchesController < ApplicationController
  before_filter :authenticate, except: [:index, :show]
  load_and_authorize_resource :tournament
  load_and_authorize_resource :match

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @match.update_attributes params[:match], as: current_user.role
      redirect_to tournament_path(@tournament)
    else
      flash[:notice] = 'Could not update this match.'
      redirect_to tournament_path(@tournament)
    end
  end
end
