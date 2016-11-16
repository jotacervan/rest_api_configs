class Itempizza < Item

  belongs_to :order

  def setPrice
  	price = 0.0
  	price1 = 0.0
  	price2 = 0.0 
  	table1 = self.order.store.price_tables.where(:pizza_id => self.item1_id, :tamanho_id => self.size_id)
  	
    if table1.count > 0
  		price1 = table1.first.price
  	end
  	
    if !item2_id.nil?
    	table = self.order.store.price_tables.where(:pizza_id => self.item2_id, :tamanho_id => self.size_id)
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
    # puts "***************"
    # puts price
    # puts price1
    # puts price2
    # puts order.store.name
    # puts size_id
    # puts price2
    # puts table1.count
    # puts table1.first.price
    # aaaa

  end

end
