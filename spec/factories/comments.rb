FactoryGirl.define do
  factory :comment do
    text { Forgery('lorem_ipsum').paragraph }
    association :user
    association :pin
  end

end
