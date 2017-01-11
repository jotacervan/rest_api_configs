class Border
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String
  field :base_value, type: Float
  field :sweet, type: Boolean, default: false
  field :codigo, type: String
  field :available, type: Boolean, :default => true

  has_and_belongs_to_many :stores
  has_and_belongs_to_many :combos
  has_many :price_tables

  def self.mapBorders (array, store, tamanhos)
    array = array.map { |u| {:id => u.id,
     :name => u.name,
     :sweet => u.sweet,
     :prices => PriceTable.getPriceBorder(u, store, tamanhos)
    }}
    array
    array.reject { |c| (c[:prices].nil? || c[:prices].count == 0) }

  end

end
