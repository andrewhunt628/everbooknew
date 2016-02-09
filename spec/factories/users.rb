FactoryGirl.define do
  factory :user do
    email      { Forgery('email').address }
    password              '11223344'
    password_confirmation '11223344'
  end

end
