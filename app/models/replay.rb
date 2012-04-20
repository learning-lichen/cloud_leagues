class Replay < ActiveRecord::Base
  # Associations
  belongs_to :game
  
  # Validations
  validates :game_id, presence: true
  validates :replay_url, presence: true
  validates :uploader_id, presence: true, uniqueness: { scope: :game_id }
end
