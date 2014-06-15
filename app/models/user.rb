class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :provider, :uid, :avatar, :fbtoken
  # attr_accessible :title, :body

  has_many :pronostics

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    if not auth[:info][:email]
      auth[:info][:email]=auth.uid + "@facebook.com"
    end
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           avatar:auth.info.image,
                           fbtoken:auth.credentials.token,
                           password:Devise.friendly_token[0,20],
        )
      end    end
  end
end
