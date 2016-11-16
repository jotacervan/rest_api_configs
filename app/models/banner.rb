class Banner
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :name, type: String
  field :url, type: String
  field :subtitle, type: String
  field :position, type: Integer, :default => 1
  field :description, type: String

  has_mongoid_attached_file :picture,
    :storage        => :s3,
    :bucket_name    => 'PIZZAPRIME',
    :bucket    => 'PIZZAPRIME',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml')

  belongs_to :store

  def self.mapBanners (array)
    array.map { |u| {:id => u.id,
     :name => u.name,
     :subtitle => u.subtitle,
     :url => u.url,
     :description => u.description,
     :picture => u.picture.url
     }}
  end

end
