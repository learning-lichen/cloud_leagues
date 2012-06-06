class Replay < ActiveRecord::Base
  # Associations
  belongs_to :game
  has_attached_file :replay
  
  # Validations
  validates :game_id, presence: true
  validates :uploader_id, presence: true, uniqueness: { scope: :game_id }
  validates_attachment :replay, presence: true, size: { in: 0..1000.kilobytes, message: I18n.t('activerecord.errors.models.replay.attributes.replay.size') }
end
