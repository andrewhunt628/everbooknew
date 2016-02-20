class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :pin
  
  validates :pin, :text, presence: true  
end
