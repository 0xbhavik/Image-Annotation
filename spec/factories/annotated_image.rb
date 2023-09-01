FactoryBot.define do
    factory :annotated_image do
      name { 'Sample' }
      image { Rack::Test::UploadedFile.new('spec/fixtures/sample.jpg', 'image/jpeg') } 
      annotations { { key1: 'value1', key2: 'value2' } }
    end
  end