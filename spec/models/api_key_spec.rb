require 'rails_helper'

RSpec.describe ApiKey, type: :model do

  let(:api_key) {FactoryGirl.build(:api_key)}
  let(:api_expired) {FactoryGirl.build(:api_expired)}
  
  context "when apikey is exists" do
    it "will success create api_key" do
      p api_key.new_record?
      expect(api_key.save).to eq(true)
    end
  end

  describe "#generate" do
    it "will generate an Array" do
      gen = ApiKey.generate
      expect(gen).to be_an(Array) 
    end

    it "and return 2 value" do
      gen = ApiKey.generate
      expect(gen.length).to eq(2)
    end
  end

  describe "#is_expired?" do
    context "when expired_date less than today" do
      it "will expired" do
        api_expired.expired_date = Date.yesterday 
        expect(api_expired.is_expired?).to be true
      end
    end

    context "when expired_date greater than today" do
      it "not expired" do
        api_key.save
        expect(api_key.is_expired?).to be false
      end
    end
  end

  describe "#create_token" do
    it "will return apikey" do
      api_key.save
      expect(api_key.apikey.present?).to eq(true)
    end
  end

end
