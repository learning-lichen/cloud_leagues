class FeedbacksController < ApplicationController
  before_filter :load_resource
  authorize_resource

  def create
    if @feedback.save
      respond_to do |format|
        format.html do
          flash[:notice] = 'Thank you. Your feedback has been submitted.'
          redirect_to root_path
        end

        format.json { render json: @feedback.to_json }
      end
    else
      respond_to do |format|
        format.html do
          flash[:notice] = 'Sorry, could not submit feedback at this time.'
          redirect_to root_path
        end

        format.json { render json: @feedback.to_json }
      end
    end
  end

  protected
  def load_resource
    role = current_user.nil? ? :guest : current_user.role
    @feedback = Feedback.new params[:feedback], as: role
  end
end
