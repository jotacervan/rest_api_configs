class StoreManager < User
  include Mongoid::Document

  #address
  field :zip, type: String
  field :street, type: String
  field :number, type: Integer
  field :complement, type: String
  field :city, type: String
  field :neighborhood, type: String
  field :state, type: String
  field :country, type: String, :default => "Brasil"


  # 198.924.708-34
  # Perminio Moreira Neto

  has_and_belongs_to_many :stores
end
