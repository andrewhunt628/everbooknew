FactoryGirl.define do
  factory :pin do     
    association :album, factory: :valid_album
    after(:build) do |pin|
      pin.image = File.new(Rails.root + 'spec/fixtures/images/example1.jpg')

    end

    after(:create) do |pin|
      pin.image = File.new(Rails.root + 'spec/fixtures/images/example1.jpg')
    end
  end

end
