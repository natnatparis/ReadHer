class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]
  has_one :library
  has_many :crushes
  has_one_attached :avatar

  has_one :library, dependent: :destroy
  has_many :crushes, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :comments, dependent: :destroy

  after_create :create_library

  after_create :welcome_send, unless: :skip_sending_welcome_email
  attr_accessor :skip_sending_welcome_email

  def create_library
    Library.create(user_id: id)
  end

  def welcome_send
    UserMailer.welcome_send(self).deliver
  end

  def show
    #links the new user to its avatar
    user.avatar.attach(params[:avatar])
    @user = User.find(params[:id])
  end

  attr_writer :login

  def login
    @login || self.username || self.email
  end

end
