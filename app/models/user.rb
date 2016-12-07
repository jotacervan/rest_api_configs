class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip

  devise :database_authenticatable,:registerable,
         :recoverable, :rememberable, :trackable, :validatable
  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  field :facebook, :type => String
  field :provider, :type => String
  field :uid, :type => String
  field :name, :type => String, :default => ""
  field :username, :type => String
  field :birthDate, :type => String, :default => ""
  field :cpf, :type => String, :default => ""
  field :gender, :type => String, :default => ""
  field :birth_date, :type => String, :default => ""
  field :phone, :type => String, :default => ""
  field :email, :type => String
  field :udid, :type => String
  field :changedPhoto, :type => Boolean, :default => false
  field :used_wine, :type => Boolean, :default => false
  field :balance, type: Integer, :default => 0
  field :latitude, type: Float, :default => 0.0
  field :longitude, type: Float, :default => 0.0

  # validate :check_avatar
  validates_presence_of :name, :message => "digite um nome"
  validates_presence_of :email, :message => "digite um e-mail"
  validates_confirmation_of :password
  validates_uniqueness_of :email,:case_sensitive => true, :message => "e-mail ja cadastrado"
  #validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i , :message => "e-mail invalido" 


  has_mongoid_attached_file :picture,
    :storage        => :s3,
    :bucket_name    => 'PIZZAPRIME',
    :bucket    => 'PIZZAPRIME',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => File.join(Rails.root, 'config', 's3.yml')


   #relationships
   has_many :addresses
   has_many :cards
   has_many :orders
   has_many :notifications

  def self.koala(auth)
    access_token = auth['token']
    facebook = Koala::Facebook::API.new(access_token)
    facebook.get_object("me?fields=name,picture")
  end


  def isAttendant?
    self.class == Attendant
  end

  def isManager?
    self.class == StoreManager
  end

  def isAdmin?
    self.class == Admin
  end

  def isSuperAdmin?
    self.class == SuperAdmin
  end

  def isProvider?
    self.class == Provider
  end

  def self.mapUser (u)
    {:cpf => u.cpf,
     :created_at => u.created_at.nil? ? "" : u.created_at,
     :phone => u.phone,
     :email => u.email,
     :id => u.id,
     :picture => (u.facebook.nil? || u.changedPhoto) ?  u.picture.url(:original) : "http://graph.facebook.com/#{u.facebook}/picture?type=large",
     :name => u.name,
     :gender => u.gender,
     :facebook => !u.facebook.nil?,
     :balance => u.balance
    }
  end
  
  def self.mapUser2 (u)
    {:balance => u.balance, :facebook => !u.facebook.nil?, :gender => u.gender, :address_count => u.addresses.count, :phone => u.phone, :email => u.email, :id => u.id,  :picture => (u.facebook.nil? || u.changedPhoto) ?  u.picture.url(:original) : "http://graph.facebook.com/#{u.facebook}/picture?type=large" , :name => u.name }
  end


end
