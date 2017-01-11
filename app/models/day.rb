class Day
  include Mongoid::Document
  	
  	field :name
  	field :week_day

    has_and_belongs_to_many :price_tables

end
