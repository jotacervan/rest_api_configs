class Itemsweetpizza < Item

  belongs_to :order

  def setPrice
  	price = 0.0
  	price1 = 0.0
  	price2 = 0.0
  	table = self.order.store.price_tables.where(:sweet_pizza_id => self.item1_id, :tamanho_id => self.size_id)
  	if table.count > 0
  		price1 = table.first.price
  	end
  	
    if !item2_id.nil?
    	table = self.order.store.price_tables.where(:sweet_pizza_id => self.item2_id, :tamanho_id => self.size_id)
    	if table.count > 0
    		price2 = table.first.price
    	end 
    end
  	
  	table = self.order.store.price_tables.where(:border_id => self.border_id)
  	if table.count > 0
  		price2 += table.first.price
  		price1 += table.first.price
  	end

  	price = [price1, price2].max
    price += self.integral ? self.order.store.integral : 0
    self.unit_price = price
  	
    price *= self.quantity
  	self.price = price
  end


end
