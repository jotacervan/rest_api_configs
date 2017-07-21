class Combo
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name, type: String
  field :subtitle, type: String
  field :pizza_category, type: String
  field :beverage_category, type: String
  field :base_value, type: Float
  field :total_pizzas, type: Integer, :default => 0
  field :total_sweet_pizzas, type: Integer, :default => 0
  field :total_beverages, type: Integer, :default => 0
  field :has_souvenir, type: Boolean, :default => false
  field :available_stores, type: Array, :default => []
  
  has_mongoid_attached_file :picture,
    :storage        => :s3,
    :bucket_name    => 'PIZZAPRIME',
    :bucket    => 'PIZZAPRIME',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml')

  has_many :price_tables
  has_many :combo_parts

  
  def self.mapCombos (array, store)
    arr = array.map { |u| {
     :id => u.id,
     :title => u.name,
     :subtitle => u.subtitle,
     :picture => u.picture.url,
     :value => PriceTable.getPriceCombo(u, store)
     }}

     arr.reject { |c| (c[:value] <= 0) }

  end

  def self.mapCombosOrder (a)
    combos = []
    store = nil
    c = Combo.find(a.item1_id)
    c[:item_sweet_pizza_id] = a.item_sweet_pizza_id
    c[:item_beverage_id] = a.item_beverage_id
    c[:item_pizza_id] = a.item_pizza_id
    c[:item_pizza_2_id] = a.item_pizza_2_id
    c[:border_id] = a.border_id
    c[:quantity_pizza] = a.quantity_pizza
    c[:quantity_sweet_pizza] = a.quantity_sweet_pizza
    c[:item_souvenir_id] = a.item_souvenir_id
    c[:quantity_beverage] = a.quantity_beverage
    pizzas = a.item_pizza_2_id.nil? ? 1 : 2
    combos << c
    store = a.order.store

    combos.map { |u| {
     :id => u.id,
     :title => u.name,
     :subtitle => u.subtitle,
     :picture => u.picture.url,
     :souvenirs => a.item_souvenir_id.nil? ? nil : Souvenir.mapSouvenirs([Souvenir.find(a.item_souvenir_id)]).first,
     :border_id => a.border_id,
     :amount => PriceTable.getPriceCombo(u, store),
     :pizzas => {
     :pizzas => Pizza.mapPizzasCombo(pizzas == 2 ? [Pizza.find(u[:item_pizza_id]),Pizza.find(u[:item_pizza_2_id])] : [Pizza.find(u[:item_pizza_id])], store),
     :quantity => u[:quantity_pizza] },
     :beverages => {:beverages =>  Beverage.mapBeveragesCombo(u[:item_beverage_id].nil? ? [] : [Beverage.find(u[:item_beverage_id])], store), :quantity =>  u[:quantity_beverage]  },
     :sweet_pizzas => {:sweet_pizzas =>  SweetPizza.mapSweetPizzasCombo(u[:item_sweet_pizza_id].nil? ? [] : [SweetPizza.find(u[:item_sweet_pizza_id])], store), :quantity =>  u[:quantity_sweet_pizza]  }     
     }}.first
  end



  def self.mapCombo (u, store)
    price = PriceTable.getPriceCombo(u, store)
    restricted_ids = ["57f3be4709bed1abd5000034", "57f3be4709bed1abd5000038", "57f3be4709bed1abd5000035", "57f3be4809bed1abd5000039", "57f3be5b09bed1abd50000d3"]
    if price > 0
      json = {
       :id => u.id,
       :title => u.name,
       :subtitle => u.subtitle,
       :picture => u.picture.url,
       :amount => price,
       :borders => Border.mapBordersCombo(Border.where(:id.in => store.combo_parts.where(:combo_id => u.id.to_s).distinct(:border_ids))),
       :souvenirs => u.has_souvenir ? Souvenir.mapSouvenirs(store.souvenirs) : nil,
       :pizzas => {:pizzas => Pizza.mapPizzasCombo(Pizza.where(:id.in => store.combo_parts.where(:combo_id => u.id.to_s).distinct(:pizza_ids)), store), :quantity => u.total_pizzas },
       :beverages => {:beverages =>  Beverage.mapBeveragesCombo(Beverage.where(:id.in => store.combo_parts.where(:combo_id => u.id.to_s).distinct(:beverage_ids)), store), :quantity => u.total_beverages },
       :sweet_pizzas => {:sweet_pizzas =>  u.total_sweet_pizzas == 0 ? [] : SweetPizza.mapSweetPizzasCombo(SweetPizza.where(:id.in => store.combo_parts.where(:combo_id => u.id.to_s).distinct(:sweet_pizza_ids)), store), :quantity => u.total_sweet_pizzas }
      }
      json
    else
      {}
    end
  end


end
