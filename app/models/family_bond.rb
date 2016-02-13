class FamilyBond < ActiveRecord::Base
  belongs_to :family_member_one, class_name: "User"
  belongs_to :family_member_two, class_name: "User"

  validates :family_member_one, :family_member_two, presence: true
end
