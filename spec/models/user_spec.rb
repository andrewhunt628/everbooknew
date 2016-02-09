require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }
  let(:father) { FactoryGirl.create(:user) }
  let(:child)  { FactoryGirl.create(:user) }    

  it 'successful saved when build from FactoryGirl' do
    expect(user.save!).to eq(true)
  end


  context "not_from_family" do
    before(:each) do
      father.save!
      child.save!
      user.save!
    end
    
    it "doesn't return given user" do
      expect(User.not_from_family(user).any?{|u| u == user}).to eq(false)
    end

    it "doesn't return family" do
      father.add_family_member(child)
      expect(User.not_from_family(father).any?{|u| u == child}).to eq(false)
    end

    it "returns user which is not a member of family" do
      expect(User.not_from_family(father).any?{|u| u == user}).to eq(true)
    end
  end

  context "add_family_member" do

    it 'create new Family record' do
      expect do
        father.add_family_member(child)
      end.to change(FamilyBond, :count).by(1)
    end
  end

  context "delete_family_member" do
    let(:father) { FactoryGirl.create(:user) }
    let(:child)  { FactoryGirl.create(:user) }    

    it 'create new Family record' do
      father.add_family_member(child)

      expect do
        father.delete_family_member(child)
      end.to change(FamilyBond, :count).by(-1)
    end
  end
  
end
