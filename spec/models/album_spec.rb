require 'rails_helper'

RSpec.describe Album, type: :model do
  let(:album) { FactoryGirl.build(:album) }
  let(:valid_album) {FactoryGirl.build(:valid_album)}

  # before(:each) do
  #   album.pins.build {}   
  # end

  context "when pin missing" do
    it "fails create album" do
      # p valid_album
      expect(album.valid?).to eq(false)
    end 
  end

  context "when pin is exists" do
    it "success create album" do
      expect(valid_album.valid?).to eq(true)
    end
  end

  it 'saves successfully if build from FactoryGirl' do
    expect(valid_album.save).to eq(true)
  end

  context 'invalid' do
    after(:each) do
      expect(album.valid?).to eq(false)
    end
    
    it 'has blank title' do
      album.title = nil
    end
  end
end
