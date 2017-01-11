class Hour
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Paranoia

  field :initial_hour, type: Integer
  field :day, type: String
  field :final_hour, type: Integer
  field :day_plain, type: Integer

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


  before_save :generate_plain

  def generate_plain
    self.day_plain = -1
    if self.day.downcase.include?("segunda")
      self.day_plain = 1
    elsif self.day.downcase.include?("terça")
      self.day_plain = 2
    elsif self.day.downcase.include?("quarta")
      self.day_plain = 3
    elsif self.day.downcase.include?("quinta")
      self.day_plain = 4
    elsif self.day.downcase.include?("sexta")
      self.day_plain = 5
    elsif self.day.downcase.include?("sábado")
      self.day_plain = 6
    elsif self.day.downcase.include?("domingo")
      self.day_plain = 0
    end
  end


end
