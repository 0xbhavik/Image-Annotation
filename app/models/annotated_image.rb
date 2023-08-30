class AnnotatedImage < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  validates :name, presence: true
  validates :image, presence: true

  def self.valid_annotations?(annotations)
    annotations.each do |key, value|
      return false if (key.empty? && !value.empty?) || (value.empty? && !key.empty?) || (key.empty? && value.empty?)
    end
    true
  end
  
  def self.image_valid? (image)
    allowed_types = ['image/jpeg', 'image/png', 'image/gif']
    image.image.content_type.in?(allowed_types)
  end

end
