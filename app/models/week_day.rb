class WeekDay
  include Mongoid::Document
  include Mongoid::Document

   field :day, type: Integer
   field :init, type: String
   field :end, type: String

    belongs_to :store
end
