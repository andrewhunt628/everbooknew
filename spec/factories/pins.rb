FactoryGirl.define do
  factory :pin do     
    association :album, factory: :album
    after(:build) do |pin|
      pin.image = File.new(Rails.root + 'spec/fixtures/images/example1.jpg')

    end
  end

end
