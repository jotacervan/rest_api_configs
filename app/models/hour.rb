class Hour
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paranoia

  field :initial_hour, type: Integer
  field :day, type: String
  field :final_hour, type: Integer

  #validators
  validates_presence_of :initial_hour, :message => "digite um horario"
  validates_presence_of :final_hour, :message => "digite um horario"
  validates_presence_of :day, :message => "digite um dia"

  belongs_to :store

  def self.mapHours (array)
    array.map { |u| {
     :day => u.day,
     :from => u.initial_hour,
     :to => u.final_hour
     }}
  end

end
