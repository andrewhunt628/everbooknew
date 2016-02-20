require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryGirl.build(:comment) }

  it 'saves successfully if build from FactoryGirl' do
    expect(comment.save!).to eq(true)
  end

end
