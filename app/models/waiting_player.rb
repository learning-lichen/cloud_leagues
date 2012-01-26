class WaitingPlayer < ActiveRecord::Base
  # Associations
  belongs_to :tournament

  # Callbacks
  before_save :authorize

  protected
  def authorize
    # No external access to this model means it should always be saved.
    return true
  end
end
