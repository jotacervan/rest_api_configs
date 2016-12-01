class Store 
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  field :enabled, type: Boolean, default: false
  field :integral, type: Float, default: 4.0
  
  field :name, type: String
  field :email, type: String
  field :phone, type: String
  field :cnpj, type: String
  field :delivery_time, type: String

  field :street, type: String
  field :neighborhood, type: String
  field :number, type: String
  field :zip, type: String
  field :city, type: String
  field :state, type: String
  field :icon, type: String
  field :complement, type: String
  field :deleted, type: Boolean, default: false

  #bank_account
  field :bank_code, type: String
  field :agencia, type: String
  field :agencia_dv, type: String
  field :conta, type: String
  field :conta_dv, type: String
  field :cpf, type: String
  field :recipient_id, type: String

  #transfer info
  field :transfer_interval, type: String
  field :transfer_day, type: String

 
  has_mongoid_attached_file :picture,
    :storage        => :s3,
    :bucket_name    => 'PIZZAPRIME',
    :bucket    => 'PIZZAPRIME',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml')
  
  field :description, type: String
  field :coordinates, :type => Array

  has_many :orders
  has_one :store_manager
  has_many :hours
  has_many :zones
  has_many :banners


  has_and_belongs_to_many :pizzas
  has_and_belongs_to_many :sweet_pizzas
  has_and_belongs_to_many :tamanhos
  has_and_belongs_to_many :borders
  has_and_belongs_to_many :beverages
  has_and_belongs_to_many :combos
  has_and_belongs_to_many :pasta
  has_and_belongs_to_many :payments
  has_and_belongs_to_many :price_tables
  has_and_belongs_to_many :fidelities 
  has_and_belongs_to_many :coupons 
  
  geocoded_by :address_full       
  after_validation :geocode

  def address_full
    [street, city, state, zip].compact.join(', ')
  end

  def self.mapStores (array)
    array.map { |store| {
     :id => store.id,
     :name => store.name,
     :email => store.email,
     :delivery_time => store.delivery_time,
     :phone => store.phone,
     :address => [store.street, store.city, store.state, store.zip].compact.join(', '),
     :coordinates => store.coordinates,
     :hours => Hour.mapHours(store.hours),
     :picture => store.picture.url
     }}
  end
    
  def self.mapMenu(store)
    {
     :pizzas => Pizza.mapPizzas(store.pizzas, store),
     :sizes => Tamanho.mapTamanhos(store.tamanhos),
     :borders => Border.mapBorders(store.borders.where(:available => true), store),
     :beverages => Beverage.mapBeverages(store.beverages.where(:available => true), store),
     :sweet_pizzas => SweetPizza.mapSweetPizzas(store.sweet_pizzas.where(:available => true), store)
     }

  end

  def self.mapMenuBeverages(store)
    {
     :beverages => Beverage.mapBeverages(store.beverages.where(:available => true).asc(:name), store)
    }
  end

  def self.mapMenuPizzas(store)
    {
     :pizzas => Pizza.mapPizzas(store.pizzas.where(:available => true).asc(:name), store),
     :integral => store.integral,
     :sizes => Tamanho.mapTamanhos(store.tamanhos),
     :pastas => Pastum.mapPastas(store.pasta),
     :borders => Border.mapBorders(store.borders.where(:available => true),store),
     }
  end


  def self.mapMenuSweetPizzas(store)
    {
     :sweet_pizzas => SweetPizza.mapSweetPizzas(store.sweet_pizzas.where(:available => true).asc(:name),store),
     :sizes => Tamanho.mapTamanhos(store.tamanhos),
     :pastas => Pastum.mapPastas(store.pasta),
     :borders => Border.mapBorders(store.borders.where(:available => true),store),
     }
  end

  def self.getShipment(store, address)
    a = address
    zip = a.zip.gsub("-","").to_i
    zone = store.zones.where(:initial_zip.lte => zip, :final_zip.gte => zip).first
    zone.value
  end



end

