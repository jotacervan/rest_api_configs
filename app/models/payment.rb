class Payment
  include Mongoid::Document
   include Mongoid::Timestamps

  field :name, type: String
  field :subtitle, type: String
  field :is_app, type: Boolean, :default => true
 
  has_and_belongs_to_many :stores
  has_many :orders

  def self.mapPayments (array)
    array.map { |u| {:id => u.id,
     :name => u.name,
     :subtitle => u.subtitle,
     :is_app => u.is_app
     }}
  end

end
