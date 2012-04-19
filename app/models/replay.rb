class Replay < ActiveRecord::Base
  # Associations
  belongs_to :match
  
  # Validations
  validates :match_id, presence: true
  validates :replay_url, presence: true
  validates :uploader_id, presence: true
  validates :game_number, presence: true, uniqueness: { scope: [:match_id, :uploader_id] }
end
