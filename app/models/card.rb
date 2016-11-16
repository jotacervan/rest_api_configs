class Card
  include Mongoid::Document
  include Mongoid::Timestamps

  #fields
  field :name, type: String
  field :token, type: String
  field :cpf, type: String
  field :brand, type: String
  field :deleted, type: Boolean, default: false

  #relationships
  belongs_to :user
  has_many :orders

  #validations
  validates_presence_of :name, :message => "digite um nome"
  validates_presence_of :token, :message => "digite um token"

  def self.mapCards (array)
    array.map { |card| {:id => card.id, :name => card.name, :brand => card.brand }}
  end

  def self.mapCard (card)
    if card.nil?
      {}
    else
      {:id => card.id, :name => card.name, :brand => card.brand }
    end
  end

end
