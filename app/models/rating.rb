class Rating
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :comment, type: String, :default => ""
  field :food, type: Integer, :default => 0
  field :delivery, type: Integer, :default => 0
  field :package, type: Integer, :default => 0
  field :cost, type: Integer, :default => 0
  field :again, type: Boolean, :default => false

  belongs_to :order

   def self.mapRating (u)
    if u.nil?
      nil
    else
      {:id => u.id,
      :package => u.package,
      :pack => u.package,
      :food => u.food,
      :delivery => u.delivery,
      :cost => u.cost,
      :again => u.again,
      :date => u.created_at.strftime("%d/%m/%Y %H:%M"),
      :comment => u.comment
      }
    end
  end

end

