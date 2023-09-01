require 'rails_helper'

RSpec.describe AnnotatedImagesController, type: :controller do
  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    it 'redirects to the index page on success' do
      post :create, params: attributes_for(:annotated_image)
      expect(flash[:notice]).to eq('Image was successfully uploaded.')
      expect(response).to redirect_to(annotated_images_path)
    end

    it 'renders the new template and show alert message if image name is empty' do
      post :create, params: attributes_for(:annotated_image , name: '')
      expect(flash[:alert]).to eq('Image name cannot be empty')
      expect(response).to render_template(:new)
    end

    it 'renders the new template if image attached is not supported' do
      post :create, params: attributes_for(:annotated_image, image: fixture_file_upload('sample.pdf'))
      expect(flash[:alert]).to eq('Only image files (jpg, jpeg, png, gif) are allowed')
      expect(response).to render_template(:new)
    end

    it 'redirects to the index page on success with no annotation' do
      post :create,
           params: { name: 'image-name', image: fixture_file_upload('sample.jpg'), custom_keys: %w[k1 k2],
                     custom_values: %w[v1 v2] }
      expect(response).to redirect_to(annotated_images_path)
    end

    it 'renders the new template with invalid annotation' do
      post :create,
           params: { name: 'image-name', image: fixture_file_upload('sample.jpg'), custom_keys: ['k1', ''],
                     custom_values: %w[v1 v2] }
      expect(flash[:alert]).to eq('Keys and values must be present')
      expect(response).to render_template(:new)
    end

    it 'renders the new template with more than 10 annotation' do
      post :create,
           params: { name: 'image-name', image: fixture_file_upload('sample.jpg'), custom_keys: %w[key1 key2 key3 key4 key5 key6 key7 key8 key9 key10 key11],
                     custom_values: %w[value1 value2 value3 value4 value5 value6 value7 value8 value9 value10 value11] }
      expect(flash[:alert]).to eq('annotations must be less than 10')
      expect(response).to render_template(:new)
    end

    it 'renders the new template with invalid annotation' do
      post :create,
           params: { name: 'image-name', image: fixture_file_upload('sample.jpg'), custom_keys: ['k1', ''],
                     custom_values: ['k1', ''] }
      expect(flash[:alert]).to eq('Keys and values must be present')
      expect(response).to render_template(:new)
    end

    it 'renders the new template if failed to save image ' do
      allow_any_instance_of(AnnotatedImage).to receive(:save).and_return(false)
      post :create,
           params: { name: 'image-name', image: fixture_file_upload('sample.jpg') }
      expect(flash[:alert]).to eq('Failed to save image')
      expect(response).to render_template(:new)
    end
  end

  describe 'Patch #update' do
    let(:annotated_image) { create(:annotated_image) }
    let(:image) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'sample.jpg'), 'image/jpeg') }

    it 'redirects to the index page on success' do
      patch :update,
            params: { id: annotated_image.id, name: 'Sample-image',
                      image: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'sample.jpg'), 'image/jpeg')  }
      annotated_image.reload
      expect(response).to redirect_to(annotated_images_path)
      expect(annotated_image.name).to eq('Sample-image')
    end

    it 'redirects to the index page on success even if image is not present in params' do
      patch :update,
            params: { id: annotated_image.id, name: 'Sample-image' }
      flash[:notice] = 'image is updated successfully.'
      expect(response).to redirect_to(annotated_images_path)
    end

    it 'renders the new template with invalid annotation' do
      patch :update,
            params: { id: annotated_image.id, name: 'Sample-image', image:  fixture_file_upload(Rails.root.join('spec', 'fixtures', 'sample.jpg'), 'image/jpeg') ,
                      custom_keys: [""], custom_values: ["v1"] }
      expect(flash[:alert]).to eq("Keys and values must be present")
      expect(response).to render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    let(:annotated_image) {create(:annotated_image)}

    context 'when image is successfully destroyed' do
      it 'redirects to annotated_images_path and sets flash notice message' do
        delete :destroy, params: { id: annotated_image.id }
        expect(response).to redirect_to(annotated_images_path)
        expect(flash[:notice]).to eq('Image is deleted successfully')
      end
    end

  end
end
