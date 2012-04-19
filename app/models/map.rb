class Map < ActiveRecord::Base
  # Associations
  has_many :map_lists
  
  # Validations
  validates :name, uniqueness: true, presence: true
  validates :download_url, uniqueness: true, presence: true
  
  # Callbacks
  before_validation :strip_inputs

  # Attribute Whitelists
  attr_accessible :name, :image_url, :download_url, as: :admin

  protected
  def strip_inputs
    name.strip! if name
    image_url.strip! if image_url
    download_url.strip! if download_url
  end
end
