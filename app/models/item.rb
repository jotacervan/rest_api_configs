class Item
  include Mongoid::Document

  field :price, type: Float
  field :unit_price, type: Float
  field :obs
  field :size_id
  field :integral, type: Boolean
  field :fidelity, type: Boolean, :default => false
  field :border_id
  field :item1_id
  field :item2_id
  field :item3_id
  field :pasta, :default => "Fina"
  field :pasta_id
  field :quantity, type: Integer


  def self.mapItems (array, sweet, order)
    array.map { |u| {
     :price => u.price,
     :quantity => u.quantity,
     :integral => u.integral,
     :size_id => u.size_id,
     :pasta => u.pasta,
     :pasta_id => u.pasta_id,
     :border_id => u.border_id,
     :size => u.size_id.nil? ? "" : Tamanho.find(u.size_id).name,
     :border => u.border_id.nil? ? "" : Border.find(u.border_id).name,
     :tastes => [ getTastes(u.item1_id, sweet, order, u.size_id), (u.item2_id.nil?) ? {} : getTastes(u.item2_id, sweet, order, u.size_id), (u.item3_id.nil?) ? {} : getTastes(u.item3_id, sweet, order, u.size_id)]
     }}
  end

  def self.mapItemsBeverages (array, order)
    array.map { |u| {
		:sku => getBeverages(u.item1_id,order), :quantity => u.quantity

     }}
  end


  def self.mapItemsCombos (array, store)
    array.map { |u| {
    :combo => Combo.mapCombosOrder(u), :quantity => u.quantity
    }}
  end



  def self.getBeverages (bv, order)
	if order.nil?
		{}
	else
		u = Beverage.find(bv)
		{:id => u.id,
	     :name => u.name,
       :category => u.category_name,
       :price =>  order.store.price_tables.where(:beverage_id => bv).first.price,
	     :picture => u.picture.url
	    }
	end
  end


  def self.getTastes (bv, sweet, order, size)
	if order.nil?
		{}
	else
		u = sweet ? SweetPizza.find(bv) : Pizza.find(bv)
		tables = sweet ? order.store.price_tables.where(:sweer_pizza_id => bv, :size_id => size) : order.store.price_tables.where(:pizza_id => bv, :size_id => size)
    price = 0
    if tables.count > 0
      price = tables.first.price
    end
    {:id => u.id,
       :name => u.name,
       :description => u.description,
       :price => price,
       :category => Category.mapCategory(u.category),
	     :picture => u.picture.url
	    }
	 end
  end



end


