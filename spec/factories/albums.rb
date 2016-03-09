FactoryGirl.define do
  factory :album do
    title { Forgery('name').industry }

    # trait :pins do
      # association :pin, factory: :pin, image: File.new(Rails.root + 'spec/fixtures/images/example1.jpg')
    # end
  end

  factory :valid_album, parent: :album do |f|
    f.after(:build) do |album|
      p album
      album.pins.build({image: File.new(Rails.root + 'spec/fixtures/images/example1.jpg')})
    end
  end

end
