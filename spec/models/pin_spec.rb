require 'rails_helper'

RSpec.describe Pin, type: :model do
  let(:pin) {FactoryGirl.build(:pin)}
  let(:person_ids) do
    10.times.map {FactoryGirl.create(:user)}.map(&:id)
  end

  it 'saves successfully if it builds from FactoryGirl' do
    expect(pin.save!).to eq(true)
  end

  context 'invalid' do
    after(:each) do
      expect(pin.save).to eq(false)
    end

    it 'has blank image' do
      pin.image = nil
    end
  end

  context 'person_ids' do
    before(:each) do
      pin.save!
    end

    it '=' do
      pin.person_ids = person_ids
      pin.save!
    end

    it '' do
      pin.person_ids = person_ids
      pin.save!
      pin.reload
      expect(pin.person_ids).to eq(person_ids)
    end 
  end

  context "text_marks" do
    before(:each) do
      pin.save!
    end

    it '=Array' do
      pin.text_marks = ["Jhon", "Andrew", "Pitter", "Leonard"]
      pin.save
    end

    it '=String' do
      pin.text_marks = "Jhon,     Andrew    ,       Pitter,      Leonard"
      pin.save
      expect(pin.text_marks).to eq(["Jhon", "Andrew", "Pitter", "Leonard"])
    end

    it '' do
      pin.text_marks = ["Jhon", "Andrew", "Pitter", "Leonard"]
      pin.save
      pin.reload
      expect(pin.text_marks).to eq(["Jhon", "Andrew", "Pitter", "Leonard"])
    end
  end
end
