class Pin < ActiveRecord::Base  
  acts_as_taggable
  
  belongs_to :album
  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :people, class_name: 'User'
  
  serialize :text_marks, Array

  def text_marks=(value)
    value = value.to_s.split(",").map(&:squish).uniq unless value.instance_of?(Array)
    super(value)
  end

end
