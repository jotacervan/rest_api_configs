class Category
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String
 
  has_many :pizzas
  has_many :sweet_pizzas
  has_many :fidelities

  def self.mapCategories (array, store)
    array.map { |u| {:id => u.id,
     :name => u.name
     }}
  end

  def self.mapCategory (u)
    if u.nil?
      {}
    else
      {:id => u.id,
      :name => u.name
      }
    end
  end

end
