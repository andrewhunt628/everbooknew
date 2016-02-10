FactoryGirl.define do
  factory :pin do     
    association :user, factory: :user
    after(:build) do |pin|
      pin.image = File.new(Rails.root + 'spec/fixtures/images/example1.jpg')

    end
  end

end
