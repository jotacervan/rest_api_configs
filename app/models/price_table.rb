class PriceTable
  include Mongoid::Document
  
  field :price, type: Float

  has_and_belongs_to_many :stores
  has_and_belongs_to_many :days
  belongs_to :tamanho
  belongs_to :pizza
  belongs_to :beverage
  belongs_to :sweet_pizza
  belongs_to :border
  belongs_to :combo


	def self.mapPricesPizzas(tamanhos, stores, pizza)
		array = []
		i = 1
		day = getDay
		tamanhos.each do |tam|
			stores.price_tables.where(:tamanho_id => tam.id.to_s, :pizza_id => pizza, :day_ids.in => [day]).each do |t|
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
		day = getDay
		tamanhos.each do |tam|
			stores.price_tables.where(:tamanho_id => tam.id.to_s, :sweet_pizza_id => pizza, :day_ids.in => [day]).each do |t|
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
		day = getDay
		itens = stores.price_tables.where(:beverage_id => item, :day_ids.in => [day]).desc(:price)
		if itens.count == 0
			0.0
		else
			itens.first.price
		end
	end

	def self.getPriceBorder(item, stores, tamanhos)
		day = getDay
		array = []
		i = 1
		tamanhos.each do |tam|
			stores.price_tables.where(:tamanho_id => tam.id.to_s, :border_id => item, :day_ids.in => [day]).each do |t|
				json = {}
				json[:size_id] = tam.id
				json[:value] = t.price
				array << json
				i += 1
			end
		end
		array
	end

	def self.getDay
		week_day = DateTime.now.wday
		if week_day == 0
			week_day = 6
		else
			week_day = DateTime.now.wday - 1
		end
		Day.where(:week_day => week_day).first.id
	end

	def self.getPriceCombo(item, stores)
		day = Day.where(:week_day => DateTime.now.wday - 1).first.id
		itens = stores.price_tables.where(:combo_id => item, :day_ids.in => [day])
		if itens.count == 0
			0.0
		else
			itens.first.price
		end
	end


end
