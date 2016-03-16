class Album < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :pins
  
  validates :title, :pins, presence: true

  accepts_nested_attributes_for :pins, allow_destroy: true

  def cover
    pins.sample
  end

  def pins_for_displaying
    pins - [cover]
  end
end
