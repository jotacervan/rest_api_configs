class Coupon
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :discount, type: Float
  field :description, type: String
  field :available, type: Boolean, :default => true

  has_and_belongs_to_many :stores 
  has_many :orders 


  def self.mapCoupon (u)
    if u.nil?
      {}
    else
      {:id => u.id,
      :name => u.name,
      :discount => u.discount
      }
    end
  end

end
