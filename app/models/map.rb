class Map < ActiveRecord::Base
  # Associations
  has_many :map_lists
  has_attached_file :image, styles: { small: ["200x200#", :png] }, default_url: '/assets/loser_pick.png'
  
  # Validations
  validates :name, uniqueness: true, presence: true
  validates_attachment :image, content_type: { content_type: ['image/jpeg', 'image/pjpeg', 'image/png'], message: I18n.t('activerecord.errors.models.map.attributes.image.content_type') }, size: { in: 0..500.kilobytes, message: I18n.t('activerecord.errors.models.map.attributes.image.size') }
  
  # Callbacks
  before_validation :strip_inputs

  # Attribute Whitelists
  attr_accessible :name, :image, as: :admin

  protected
  def strip_inputs
    name.strip! if name
  end
end
