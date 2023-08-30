require 'rails_helper'

RSpec.describe AnnotatedImage, type: :model do
  let(:image) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'sample.jpg'), 'image/jpeg') }
  let(:txt) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'sample.txt'), 'text/plain') }
  let(:pdfFile) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'sample.pdf')) }

  describe 'validations' do
    it 'is valid with a name and image' do
      annotated_image = AnnotatedImage.new(name: 'Image-name', image: image)
      expect(annotated_image).to be_valid
    end

    it 'is invalid without a name' do
      annotated_image = AnnotatedImage.new(name: nil, image: image)
      expect(annotated_image).not_to be_valid
    end

    it 'is invalid without a image' do
      annotated_image = AnnotatedImage.new(name: 'image-name', image: nil)
      expect(annotated_image).not_to be_valid
    end
  end

  describe '.valid_annotations?' do
    it 'returns true for valid annotations' do
      annotations = { 'key1' => 'value1', 'key2' => 'value2' }
      expect(AnnotatedImage.valid_annotations?(annotations)).to be_truthy
    end

    it 'returns false for invalid annotations (value is null)' do
      annotations = { 'key1' => 'value1', 'key2' => '', 'key3' => 'value3' }
      expect(AnnotatedImage.valid_annotations?(annotations)).to be_falsy
    end
    it 'returns false for invalid annotations (key is null)' do
      annotations = { 'key1' => 'value1', '' => 'value2', 'key3' => 'value3' }
      expect(AnnotatedImage.valid_annotations?(annotations)).to be_falsy
    end
    it 'returns false for invalid annotations (both key and value is null)' do
      annotations = { 'key1' => 'value1', '' => '', 'key3' => 'value3' }
      expect(AnnotatedImage.valid_annotations?(annotations)).to be_falsy
    end
  end

  describe '.image_valid?' do
    it 'returns true for valid image types' do
      annotated_image = AnnotatedImage.new
      annotated_image.image.attach(image)
      expect(AnnotatedImage.image_valid?(annotated_image)).to be_truthy
    end

    it 'returns false for invalid image types (txt file)' do
      annotated_image = AnnotatedImage.new
      annotated_image.image.attach(txt)
      expect(AnnotatedImage.image_valid?(annotated_image)).to be_falsy
    end

    it 'returns false for invalid image types (pdf file)' do
      annotated_image = AnnotatedImage.new
      annotated_image.image.attach(pdfFile)
      expect(AnnotatedImage.image_valid?(annotated_image)).to be_falsy
    end
  end
end
