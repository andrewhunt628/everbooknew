# == Schema Information
#
# Table name: albums
#
#  id          :integer          not null, primary key
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  user_id     :integer
#

class Album < ActiveRecord::Base

  searchkick autocomplete: ['title']
  

  acts_as_taggable

  belongs_to :user
  has_many :pins

  validates :title, :pins, presence: true

  accepts_nested_attributes_for :pins, allow_destroy: true

  scope :by_users, -> (user_ids) { where :user_id => user_ids }
  scope :latest, -> { order :created_at => :desc }


  def cover
    pins.sample
  end

  def pins_for_displaying
    pins - [cover]
  end
end
