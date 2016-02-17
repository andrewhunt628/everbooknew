class Album < ActiveRecord::Base
  acts_as_taggable

  belongs_to :users
  has_many :pins
  
  validates :title, presence: true
end
