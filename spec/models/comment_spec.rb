require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:each) do
    @album = FactoryGirl.create(:valid_album)
  end

  let(:comment) { FactoryGirl.build(:comment) }

  it 'saves successfully if build from FactoryGirl' do
    p @album
    expect(comment.save!).to eq(true)
  end

end
