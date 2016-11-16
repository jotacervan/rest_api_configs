class Pizza
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String
  field :category_name, type: String
  field :codigo, type: String
  field :description, type: String, :default => "Pera, uva maçã e salada mista"
  field :base_value, type: Float
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
  belongs_to :category

  def self.mapPizzas (array, store)
    array.map { |u| {:id => u.id,
     :name => u.name,
     :description => u.description,
     :category => Category.mapCategory(u.category),
     :prices => PriceTable.mapPricesPizzas(Tamanho.all, store, u),
     :picture => u.picture.url
     }}
  end
  
  def self.mapPizzasCombo (array, store)
    array.map { |u| {:id => u.id,
     :name => u.name,
     :description => u.description,
     :picture => u.picture.url
     }}
  end

end
