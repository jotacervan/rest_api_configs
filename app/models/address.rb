class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :street, type: String
  field :neighborhood, type: String
  field :number, type: String
  field :zip, type: String
  field :city, type: String
  field :state, type: String
  field :type, type: Integer
  field :complement, type: String
  field :latitude, type: Float
  field :longitude, type: Float
  field :deleted, type: Boolean, default: false

  #relations
  belongs_to :user
  has_many :orders

  def self.mapAddress (u)
    {:id => u.id, :name => u.name, :street => u.street,
     :neighborhood => u.neighborhood, :number => u.number, :zip => u.zip,
     :city => u.city, :state => u.state, :type => u.type,
     :complement => u.complement, :latitude => u.latitude, :longitude => u.longitude
   }
  end

  def self.mapAddresses (array)
    array.map { |u| {:id => u.id, :name => u.name, :street => u.street,
     :neighborhood => u.neighborhood, :number => u.number, :zip => u.zip,
     :city => u.city, :state => u.state, :type => u.type,
     :complement => u.complement, :latitude => u.latitude, :longitude => u.longitude
   }}
  end


end
