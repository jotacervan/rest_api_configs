class Beverage
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String
  field :sku, type: String, :default => ""
  field :base_value, type: Float
  field :codigo, type: String
  field :category_name, type: String
  field :description, type: String
  field :is_18, type: Boolean, :default => "false"
  field :available, type: Boolean, :default => true

  has_mongoid_attached_file :picture,
    :storage        => :s3,
    :bucket_name    => 'PIZZAPRIME',
    :bucket    => 'PIZZAPRIME',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml')
  
  has_and_belongs_to_many :stores
  has_and_belongs_to_many :combos
  has_many :price_tables

  def self.mapBeverages (array, store)
    array = array.map { |u| {:id => u.id,
     :name => u.name,
     :category => u.category_name,
     :sku => u.sku,
     :value => PriceTable.getPriceBeverage(u, store),
     :points => 100,
     :is_18 => u.is_18,
     :picture => u.picture.url
     }}
     # array
     array.reject { |c| (c[:value].to_f <= 0) }
    # noEmptyArray

  end

  def self.mapBeveragesCombo (array, store)
    array.map { |u| {:id => u.id,
     :name => u.name,
     :sku => u.sku,
     :picture => u.picture.url
     }}
  end

end
