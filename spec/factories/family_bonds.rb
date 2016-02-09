FactoryGirl.define do
  factory :family_bond do     
    association :family_member_one, factory: :user
    association :family_member_two, factory: :user
  end

end
