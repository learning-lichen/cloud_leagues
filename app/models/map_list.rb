class MapList < ActiveRecord::Base
  # Associations
  belongs_to :tournament
  belongs_to :map

  # Validations
  validates :map_id, presence: true, inclusion: { in: lambda { |ml| Map.all.map { |m| m.id }}}
  validates :map_order, presence: true, inclusion: { in: 1..20 }, uniqueness: { scope: :tournament_id }
  validate :map_ordering
  
  # Attribute Whitelist
  attr_accessible :map_id, :map_order, as: :moderator
  attr_accessible :map_id, :map_order, as: :admin

  protected
  def map_ordering   
    if map_order != 1 && tournament && tournament.map_lists.select { |ml| ml.map_order == 1 }.length == 0
      errors.add :map_order, 'must be sequential'
    end
  end
end
