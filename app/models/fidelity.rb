class Fidelity
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String
  field :category, type: String
  field :type, type: String
  field :points, type: Float
 
  belongs_to :category
  belongs_to :tamanho
  has_and_belongs_to_many :stores

  def self.mapFidelities (array)
    array.map { |u| {:id => u.id,
     :name => u.name,
     :points => u.points,
     :category => Category.mapCategory(u.category),
     :size => u.tamanho.nil? ? {} : Tamanho.mapTamanhos([u.tamanho]).first,
     :type => u.type
     }}
  end

end
