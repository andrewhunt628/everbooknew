class ApiKey < ActiveRecord::Base
  belongs_to :user

  # generate key for :api_key
  # using Devise token_generator method
  def self.generate
    Devise.token_generator.generate ApiKey, :apikey
  end
end
