FactoryGirl.define do
  factory :album do
    title { Forgery('name').industry }
  end

  factory :valid_album, parent: :album do
    after(:build) do |album|
      album.pins.build({image: File.new(Rails.root + 'spec/fixtures/images/example1.jpg')})
    end

    after(:create) do |album|
      album.pins.create({image: File.new(Rails.root + 'spec/fixtures/images/example1.jpg')})
    end
  end

end
