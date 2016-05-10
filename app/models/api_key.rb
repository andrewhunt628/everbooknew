# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  apikey       :string           not null
#  expired_date :date             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_api_keys_on_user_id  (user_id)
#

class ApiKey < ActiveRecord::Base
  belongs_to :user

  before_create :create_token

  # generate key for :api_key
  # using Devise token_generator method
  def self.generate
    Devise.token_generator.generate ApiKey, :apikey
  end

  # to check is token expired?
  def is_expired?
    self.expired_date < Date.today
  end

  # save token into database
  def create_token
    begin
      self.apikey = ApiKey.generate[1].to_s
      # set expired date for apikey until the day changed
      self.expired_date = Date.today + 1

    end while self.class.exists?(apikey: apikey)
  end
end
