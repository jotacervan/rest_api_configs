class Provider < User
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name
  field :cnpj

  #bank_account
  field :bank_code, type: String
  field :agencia, type: String
  field :agencia_dv, type: String
  field :conta, type: String
  field :conta_dv, type: String
  field :cpf, type: String
  field :recipient_id, type: String

  #transfer info
  field :transfer_interval, type: String
  field :transfer_day, type: String

  has_mongoid_attached_file :picture,
    :storage        => :s3,
    :bucket_name    => 'PIZZAPRIME',
    :bucket    => 'PIZZAPRIME',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml')
  
  field :description, type: String

  has_many :stores
end
