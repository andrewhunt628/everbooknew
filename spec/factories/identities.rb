FactoryGirl.define do
  factory :identity do
    association :user
    provider "MyString"
    uid "MyString"
  end

  factory :identity_invalid, parent: :identity do
    provider nil
    uid nil
  end

end
