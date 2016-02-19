require 'rails_helper'

RSpec.describe Album, type: :model do
  let(:album) { FactoryGirl.build(:album) }

  it 'saves successfully if build from FactoryGirl' do
    expect(album.save).to eq(true)
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
