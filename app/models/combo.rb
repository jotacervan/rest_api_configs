class Combo
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String
  field :subtitle, type: String
  field :pizza_category, type: String
  field :beverage_category, type: String
  field :base_value, type: Float
  field :total_pizzas, type: Integer, :default => 0
  field :total_sweet_pizzas, type: Integer, :default => 0
  field :total_beverages, type: Integer, :default => 0

  has_mongoid_attached_file :picture,
    :storage        => :s3,
    :bucket_name    => 'PIZZAPRIME',
    :bucket    => 'PIZZAPRIME',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml')



  has_and_belongs_to_many :stores
  has_and_belongs_to_many :orders
  has_many :price_tables

  def self.mapCombos (array)
    array.map { |u| {
     :id => u.id,
     :title => u.name,
     :subtitle => u.subtitle,
     :picture => u.picture.url
     }}
  end

  def self.mapCombosOrder (a)
    combos = []
    store = nil
    c = Combo.find(a.item1_id)
    c[:item_sweet_pizza_id] = a.item_sweet_pizza_id
    c[:item_beverage_id] = a.item_beverage_id
    c[:item_pizza_id] = a.item_pizza_id
    c[:quantity_pizza] = a.quantity_pizza
    c[:quantity_sweet_pizza] = a.quantity_sweet_pizza
    c[:quantity_beverage] = a.quantity_beverage
    
    combos << c
    store = a.order.store

    combos.map { |u| {
     :id => u.id,
     :title => u.name,
     :subtitle => u.subtitle,
     :picture => u.picture.url,
     :amount => PriceTable.getPriceCombo(u, store),
     :pizzas => {
     :pizzas => Pizza.mapPizzasCombo(u[:item_pizza_id].nil? ? [] : [Pizza.find(u[:item_pizza_id])], store),
     :quantity => u[:quantity_pizza] },
     :beverages => {:beverages =>  Beverage.mapBeveragesCombo(u[:item_beverage_id].nil? ? [] : [Beverage.find(u[:item_beverage_id])], store), :quantity =>  u[:quantity_beverage]  },
     :sweet_pizzas => {:sweet_pizzas =>  SweetPizza.mapSweetPizzasCombo(u[:item_sweet_pizza_id].nil? ? [] : [SweetPizza.find(u[:item_sweet_pizza_id])], store), :quantity =>  u[:quantity_sweet_pizza]  }     
     }}.first
  end



  def self.mapCombo (u, store)
    json = {
     :id => u.id,
     :title => u.name,
     :subtitle => u.subtitle,
     :picture => u.picture.url,
     :amount => PriceTable.getPriceCombo(u, store),
     :pizzas => {:pizzas => Pizza.mapPizzasCombo(u.pizza_category == "all" ? store.pizzas : store.pizzas.where(:category_name => u.pizza_category), store), :quantity => u.total_pizzas },
     :beverages => {:beverages =>  Beverage.mapBeveragesCombo(u.beverage_category == "all" ? store.beverages : store.beverages.where(:category_name => u.beverage_category), store), :quantity => u.total_beverages },
     :sweet_pizzas => {:sweet_pizzas =>  u.total_sweet_pizzas == 0 ? [] : SweetPizza.mapSweetPizzasCombo(store.sweet_pizzas, store), :quantity => u.total_sweet_pizzas }
    }
    json
  end


end
