require 'rails_helper'

RSpec.describe Identity, type: :model do
  let(:user) {FactoryGirl.create(:user)}

  context "when uid or provider missing" do
    it "will fails create Identity" do
      expect {FactoryGirl.create(:identity_invalid)}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "when uid or provider exists" do
    it "will create Identity" do
      identity = FactoryGirl.create(:identity)
      expect(identity).to be_valid
    end
  end

  it "uid must unique scope by provider" do
    FactoryGirl.create(:identity)

    expect {
      FactoryGirl.create(:identity)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

end
