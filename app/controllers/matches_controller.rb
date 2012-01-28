class MatchesController < ApplicationController
  before_filter :authenticate, except: [:show]
  load_and_authorize_resource
  
  def show
  end

  def new
  end

  def create
    @match = Match.new params[:match], as: current_user.role

    if @match.save
      redirect_to match_path(@match)
    else
      render action: :new
    end
  end
  
  def edit
  end

  def update
    if @match.update_attributes params[:match], as: current_user.role
      redirect_to match_path(@match)
    else
      render action: :edit
    end
  end

  def destroy
    flash[:notice] = 'Match successfully destroyed.'
    tournament = @match.tournament
    @match.destroy
    redirect_to tournament_path(tournament)
  end
end
