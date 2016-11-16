class Itemcombo < Item

  field :quantity_pizza, type: Integer, :default => 0
  field :quantity_sweet_pizza, type: Integer, :default => 0
  field :quantity_beverage, type: Integer, :default => 0
  field :item_pizza_id
  field :item_beverage_id
  field :item_sweet_pizza_id

  belongs_to :order

  def setPrice
  	price = 0.0
  	table = self.order.store.price_tables.where(:combo_id => self.item1_id)
  	if table.count > 0
  		price = table.first.price
  	end
    self.unit_price = price
  	price *= self.quantity
  	self.price = price

  end

end
