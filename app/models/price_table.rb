class PriceTable
  include Mongoid::Document
  
  field :price, type: Float

  has_and_belongs_to_many :stores
  belongs_to :tamanho
  belongs_to :pizza
  belongs_to :beverage
  belongs_to :sweet_pizza
  belongs_to :border
  belongs_to :tamanho
  belongs_to :combo


	def self.mapPricesPizzas(tamanhos, stores, pizza)
		array = []
		i = 1
		Tamanho.all.each do |tam|
			stores.price_tables.where(:tamanho_id => tam.id.to_s, :pizza_id => pizza).each do |t|
				json = {}
				json[:size_id] = tam.id
				json[:value] = t.price
				json[:points] = 100
				array << json
				i += 1
			end
		end
		array
	end

	def self.mapPricesSweetPizzas(tamanhos, stores, pizza)
		array = []
		i = 1
		Tamanho.all.each do |tam|
			stores.price_tables.where(:tamanho_id => tam.id.to_s, :sweet_pizza_id => pizza).each do |t|
				json = {}
				json[:size_id] = tam.id
				json[:value] = t.price
				json[:points] = 100
				array << json
				i += 1
			end
		end
		array
	end

	def self.getPriceBeverage(item, stores)
		itens = stores.price_tables.where(:beverage_id => item)
		if itens.count == 0
			0.0
		else
			itens.first.price
		end
	end
	def self.getPriceBorder(item, stores)
		itens = stores.price_tables.where(:border_id => item)
		if itens.count == 0
			0.0
		else
			itens.first.price
		end
	end
	def self.getPriceCombo(item, stores)
		itens = stores.price_tables.where(:combo_id => item)
		if itens.count == 0
			0.0
		else
			itens.first.price
		end
	end


end
