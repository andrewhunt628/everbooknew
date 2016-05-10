# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string
#  uid                    :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  first_name             :string
#  last_name              :string
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  location               :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # include Devise invitable module helper
  include DeviseInvitable::Inviter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :trackable, :validatable,
         :omniauthable #:omniauth_providers => [:facebook]

  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update

  has_many :pins
  has_many :albums
  has_many :comments
  has_many :family_bonds, foreign_key: 'family_member_one_id'
  has_many :family, through: :family_bonds, source: :family_member_two

  # destroy Api key when user destroyed
  has_one :api_key, dependent: :destroy
  has_many :identities


  has_friendship

  acts_as_tagger


  has_attached_file :avatar, default_url: "/avatars/avatar#{rand(3)+1}.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  # create api_key after user created by default
  after_create :create_apikey


  scope :all_except, ->(user) { where.not(:id => user) }


  def update_location! ip
    return if  (self.location.present? && (self.location != 'Reserved'))

    location = Geocoder.search(ip).first.data['country_name']

    self.update_attributes :location => location
  end

  def invited_user?
    (self.invited_to_sign_up?) && (self.sign_in_count == 0)
  end


  def invite_new_user! email
    User.invite! :email => email
  end


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

  def self.find_for_oauth(auth, signed_in_resource = nil, ip)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup


      # since google oauth doesn't provide "auth.info.verified" object,
      # so we can check, if it's google_oauth2, then we can bypass condition check "auth.info.verified"
      if auth.provider.eql? "google_oauth2"
        email_is_verified = auth.info.email
      elsif auth.provider.eql? "facebook"
        auth.extra.raw_info.given_name = auth.info.name
        avatar = HTTParty.get(auth.info.image, follow_redirects: false)
        auth.extra.raw_info.picture = avatar.headers['location']
        email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      else
        email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      end

      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          first_name: auth.extra.raw_info.given_name,
          last_name: auth.extra.raw_info.family_name,
          avatar: URI.parse(auth.extra.raw_info.picture),
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        # if module Devise :confirmable is included
        # user.skip_confirmation!

        # use this module Devise :confirmable is not include
        user.skip_confirmation! if user.respond_to?(:skip_confirmation)
        user.save!
      else
        user.update_attributes :avatar => URI.parse(auth.extra.raw_info.picture)
      end
    else
      user.delay.update_location! ip
    end


    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
