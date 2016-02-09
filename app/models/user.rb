class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :pins
  has_many :family_bonds, foreign_key: 'family_member_one_id'
  has_many :family, through: :family_bonds, source: :family_member_two

  def add_family_member(user)
    family_bonds.create! family_member_two: user
  end

  def delete_family_member(user)
    family_bonds.where(family_member_two_id: user.id).destroy_all
  end
end
