require 'rails_helper'

RSpec.describe FamilyBond, type: :model do
  let(:family_bond) {FactoryGirl.build(:family_bond)}

  it 'saves successfully if it builds from FactoryGirl' do
    expect(family_bond.save!).to eq(true)
  end

  context 'invalid' do
    after(:each) do
      expect(family_bond.save).to eq(false)
    end

    it 'has blank family_member_one' do
      family_bond.family_member_one = nil
    end

    it 'has blank family_member_two' do
      family_bond.family_member_two = nil
    end
  end
end
