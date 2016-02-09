require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  it 'successful saved when build from FactoryGirl' do
    expect(user.save!).to eq(true)
  end

  context "add_family_member" do
    let(:father) { FactoryGirl.create(:user) }
    let(:child)  { FactoryGirl.create(:user) }    

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
