class HomeImage
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String

  has_mongoid_attached_file :picture,
    :storage        => :s3,
    :bucket_name    => 'PIZZAPRIME',
    :bucket    => 'PIZZAPRIME',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml')

  belongs_to :store

  def self.mapImages (array)
    array.map { |u| {:id => u.id,
     :name => u.name,
     :picture => u.picture.url
     }}
  end

end
