class Map < ActiveRecord::Base
  # Associations
  has_many :map_lists
  
  # Validations
  validates :name, uniqueness: true, presence: true
  validates :image_url, presence: true
  
  # Callbacks
  before_validation :strip_inputs

  # Attribute Whitelists
  attr_accessible :name, :image_url, as: :admin

  protected
  def strip_inputs
    name.strip! if name
    image_url.strip! if image_url
  end
end
