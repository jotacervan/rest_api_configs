class Notification
  include Mongoid::Document

  field :message, type: String
  field :seen, type: Boolean, :default => false
  field :service, type: String
  belongs_to :user
  
end
