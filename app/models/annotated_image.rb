class AnnotatedImage < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  validates :name, presence: true

  def self.valid_annotations?(annotations)
    annotations.each do |key, value|
      return false if (key.empty? && !value.empty?) || (value.empty? && !key.empty?) || (key.empty? && value.empty?)
    end
    true
  end
end
