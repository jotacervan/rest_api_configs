class Portfolio
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String
  field :caption, type: String
  field :address, type: String
  field :likes, type: Integer
  field :latitude, type: Float
  field :longitude, type: Float

  has_mongoid_attached_file :picture,
    :storage        => :s3,
    :bucket_name    => 'loqk',
    :bucket    => 'loqk',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml')


   belongs_to :store

end

