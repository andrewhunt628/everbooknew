# == Schema Information
#
# Table name: pins
#
#  id                 :integer          not null, primary key
#  title              :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  text_marks         :text
#  album_id           :integer
#  user_id            :integer
#

class Pin < ActiveRecord::Base

  searchkick autocomplete: ['title', 'album_name', 'tag_name'], settings: {number_of_shards: 1}


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

  scope :by_latest, -> { order :created_at => :desc }


  def search_data
    {
      :title => title,
      :album_name => album.title,
      tag_name: tags.map(&:name),
      :user_id => user_id,
      :album_id => album_id
    }
  end

  def text_marks=(value)
    value = value.to_s.split(",").map(&:squish).uniq unless value.instance_of?(Array)
    super(value)
  end

end
