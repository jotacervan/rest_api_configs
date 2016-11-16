class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  field :cpf, type: String 
  field :number, type: String, :default => "11"
  field :status, type: String, :default => "Pendente"
  field :amount, type: Float, :default => 0
  field :change, type: Float, :default => 0
  field :shipment, type: Float, :default => 0
  field :pick_in_store, type: Boolean, :default => false
  field :discount, type: Float, :default => 0
  field :transaction_id
  field :udid
  
  #relationships
  belongs_to :address
  belongs_to :card
  belongs_to :user
  belongs_to :store
  has_many :itembeverages
  has_many :itempizzas
  has_many :itemsweetpizzas
  has_many :itemcombos
  has_one :rating
  belongs_to :payment
  has_and_belongs_to_many :combos
  belongs_to :coupon


  def self.mapOrders (array)
    array.map { |u| {
     :id => u.id,
     :store => u.store.name,
     :store_id => u.store.id,
     :number => u.number,
     :status => u.status,
     :amount => u.amount,
     :date => u.created_at.strftime("%d/%m/%Y %H:%M"),
     :shipment => u.shipment,
     :discount => u.discount

     }}
  end


  def setAmount
    amount = 0.0
    self.itembeverages.each do |item|
      amount +=  item.price
    end
    self.itemsweetpizzas.each do |item|
      amount +=  item.price
    end
    self.itempizzas.each do |item|
      amount +=  item.price
    end
    self.itemcombos.each do |item|
      amount += item.price
    end
    self.amount = amount
    self.amount += self.shipment
  end

  def self.mapOrder (u)

   {:order => u.id,
    :store => u.store.name,
    :store_id => u.store_id,
    :status => u.status,
    :number => u.number,
    :date => u.created_at.strftime("%d/%m/%Y %H:%M"),
    :amount => u.amount,
    :pizzas => Item.mapItems(u.itempizzas, false, u),
    :sweeet_pizzas => Item.mapItems(u.itemsweetpizzas, true, u),
    :sweet_pizzas => Item.mapItems(u.itemsweetpizzas, true, u),
    :beverages => Item.mapItemsBeverages(u.itembeverages, u),
    :address => Address.mapAddress(u.address),
    :card => Card.mapCard(u.card),
    :payment => Payment.mapPayments([u.payment]).first,
    :shipment => u.shipment,
    :combos => Item.mapItemsCombos(u.itemcombos, u.store),
    :discount => u.discount,
    :rating => Rating.mapRating(u.rating)
  }
 end
end
