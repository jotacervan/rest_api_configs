class Pastum
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String
  field :base_value, type: Float
 
  
  has_and_belongs_to_many :stores
  has_and_belongs_to_many :combos

  def self.mapPastas (array)
    array.map { |u| {
     :id => u.id,
     :name => u.name,
     :price => 0
     }}
  end

end