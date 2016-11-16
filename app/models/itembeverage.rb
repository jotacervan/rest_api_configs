class Itembeverage < Item

  belongs_to :order

  def setPrice
  	price = 0.0
  	table = self.order.store.price_tables.where(:beverage_id => self.item1_id)
  	if table.count > 0
  		price = table.first.price
  	end
    self.unit_price = price
  	price *= self.quantity
  	self.price = price
  end

end
