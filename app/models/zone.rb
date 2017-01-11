class Zone
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paranoia
  include Mongoid::Geospatial

  field :initial_zip, type: Integer
  field :name, type: String
  field :final_zip, type: Integer
  field :value, type: Float, :default => 10.0
  field :area,  type: Polygon
  field :area_string,  type: String

  #validators
  # validates_presence_of :initial_zip, :message => "digite um cep"
  # validates_presence_of :final_zip, :message => "digite um cep"
  validates_presence_of :name, :message => "digite um nome"

  belongs_to :store
end
                                                                                                                                                                                                                                                                                                                                