class Album < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :pins
  
  validates :title, presence: true

  accepts_nested_attributes_for :pins, allow_destroy: true, reject_if: proc { |attributes| attributes['image'].blank? }

  def cover
    pins.first
  end

  def pins_for_displaying
    pins - [cover]
  end
end
