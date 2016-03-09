FactoryGirl.define do
  factory :api_key do
    expired_date Date.today+1
    association :user
  end

  factory :api_expired, parent: :api_key do
    expired_date Date.yesterday
  end

end
