class User < ActiveRecord::Base
  # include Devise invitable module helper
  include DeviseInvitable::Inviter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :pins
  has_many :albums
  has_many :comments
  has_many :family_bonds, foreign_key: 'family_member_one_id'
  has_many :family, through: :family_bonds, source: :family_member_two

  # destroy Api key when user destroyed
  has_one :api_key, dependent: :destroy

  # create api_key after user created by default
  after_create :create_apikey

  def create_apikey
    ApiKey.create user: self
  end

  def self.not_from_family(user)
    family_ids = user.family_ids
    family_ids.push(user.id)
    all.where.not(id: family_ids)
  end

  def add_family_member(user)
    family_bonds.create! family_member_two: user
  end

  def delete_family_member(user)
    family_bonds.where(family_member_two_id: user.id).destroy_all
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_name
    Forgery::Name.first_name
  end

  def last_name
    Forgery::Name.last_name
  end

  def avatar
    "/avatars/avatar#{rand(3)+1}.jpg"
  end

  # get or create new user from facebook
  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)
    return user if user.present?
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.find_for_verify_google_token(userprofile, uid = "", provider = "")
    user = User.find_by(email: userprofile[:email])
    return user if user.present?
    where(provider: provider, uid: uid).first_or_create do |user|
      user.email = userprofile[:email]
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
