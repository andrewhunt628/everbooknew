class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :pins
  has_many :family_bonds, foreign_key: 'family_member_one_id'
  has_many :family, through: :family_bonds, source: :family_member_two

  def self.not_from_family(user)
    family_ids = user.family_ids
    family_ids.push(user.id)
    all.where.not(id: family_ids)
  end

  def add_family_member(user)
    family_bonds.create! family_member_two: user
  end

  def delete_family_member(user)
    family_bonds.where(family_member_two_id: user.id).destroy_all
  end

  def name
    Forgery::Name.first_name
  end

  def last_name
    Forgery::Name.last_name
  end
end
