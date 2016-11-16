class Wine
  include Mongoid::Document
  field :name, type: String
  field :available, type: Boolean, :default => true

end
