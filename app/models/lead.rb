class Lead
  include Mongoid::Document
  include Mongoid::Timestamps


  field :id_cliente
  field :id_oportunidade
  field :name
  field :name
  field :email
  field :cidade
  field :bairro
  field :estado
  field :phone
  field :cpf

end
