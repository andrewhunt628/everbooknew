# == Schema Information
#
# Table name: family_bonds
#
#  id                   :integer          not null, primary key
#  family_member_one_id :integer
#  family_member_two_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class FamilyBond < ActiveRecord::Base
  belongs_to :family_member_one, class_name: "User"
  belongs_to :family_member_two, class_name: "User"

  validates :family_member_one, :family_member_two, presence: true
end
