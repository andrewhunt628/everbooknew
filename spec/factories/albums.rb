FactoryGirl.define do
  factory :album do
    title { Forgery('name').industry }
  end

end
