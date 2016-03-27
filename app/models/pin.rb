class Pin < ActiveRecord::Base  
  acts_as_taggable
  
  belongs_to :album
  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :people, class_name: 'User'
  
  serialize :text_marks, Array

  has_attached_file :image, styles: {
      album_cover: '260x180',
      upload_thumb: '200x140',
      medium: '300x300>',
      thumb: '100x100>',
      small: '70x70>',
      popup: '580x454>'
  }, default_url: '/images/:style/missing.png'
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates :image, presence: true

  def text_marks=(value)
    value = value.to_s.split(",").map(&:squish).uniq unless value.instance_of?(Array)
    super(value)
  end

end
