FactoryGirl.define do
  factory :user do
    email      { Forgery('email').address }
    password              '11223344'
    password_confirmation '11223344'
  end

  factory :user_fail_login, parent: :user do
    password "123124"
    password_confirmation "12319879"
  end

end
