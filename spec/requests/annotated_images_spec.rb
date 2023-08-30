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
      post :create, params: { name: 'Sample', image: fixture_file_upload('sample.jpg', 'image/jpeg') }
      expect(response).to redirect_to(annotated_images_path)
    end

    it 'renders the new template if image name is empty' do
      post :create, params: { name: '', image: nil }
      expect(response).to render_template(:new)
    end

    it 'renders the new template if image is not attached' do
      post :create, params: { name: 'image-name', image: nil }
      expect(response).to render_template(:new)
    end
    it 'renders the new template if image attached is not supported' do
      post :create, params: { name: 'image-name', image: fixture_file_upload('sample.pdf') }
      expect(response).to render_template(:new)
    end

    it 'redirects to the index page on success with valid annotation' do
      post :create,
           params: { name: 'image-name', image: fixture_file_upload('sample.jpg'), custom_keys: %w[k1 k2],
                     custom_values: %w[v1 v2] }
      expect(response).to redirect_to(annotated_images_path)
    end

    it 'renders the new template with invalid annotation' do
      post :create,
           params: { name: 'image-name', image: fixture_file_upload('sample.jpg'), custom_keys: ['k1', ''],
                     custom_values: %w[v1 v2] }
      expect(response).to render_template(:new)
    end

    it 'renders the new template with invalid annotation' do
      post :create,
           params: { name: 'image-name', image: fixture_file_upload('sample.jpg'), custom_keys: ['k1', ''],
                     custom_values: ['k1', ''] }
      expect(response).to render_template(:new)
    end
  end

  describe 'Patch #update' do

    let(:annotated_image) { AnnotatedImage.create(name: 'Test Image' , image: fixture_file_upload('sample.jpg', 'image/jpeg') )}
    let(:image) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'sample.jpg'), 'image/jpeg') }

    it 'redirects to the index page on success' do
      patch :update, params: { id: annotated_image.id , name: 'Sample-image', image: fixture_file_upload('sample.jpg', 'image/jpeg') }
      expect(response).to redirect_to(annotated_images_path)
    end

    it 'renders the new template with invalid annotation' do
      patch :update, params: { id: annotated_image.id , name: 'Sample-image', image: fixture_file_upload('sample.jpg', 'image/jpeg'), custom_keys: [''] , custom_values: ['v1'] }
      expect(response).to render_template(:edit)
    end
  end 

  describe 'POST #update_annotation' do
    let(:annotated_image) { AnnotatedImage.create(name: 'Sample Image') }

    context 'with valid annotations' do
      before do
        allow(controller).to receive(:set_annotation).and_return({})
        allow(AnnotatedImage).to receive(:valid_annotations?).and_return(true)
        allow_any_instance_of(AnnotatedImage).to receive(:save).and_return(true)
        post :update_annotation, params: { id: annotated_image.id }, format: :js
      end

      it 'sets flash notice message' do
        expect(flash[:notice]).to eq('Annotations updated successfully.')
      end

      it 'renders the update_annotation.js.erb template' do
        expect(response).to render_template('update_annotation')
      end
    end

    context 'with invalid annotations' do
      before do
        allow(controller).to receive(:set_annotation).and_return({})
        allow(AnnotatedImage).to receive(:valid_annotations?).and_return(false)
        post :update_annotation, params: { id: annotated_image.id }, format: :js
      end

      it 'sets flash alert message' do
        expect(flash[:alert]).to eq('Keys and values must be present')
      end

      it 'renders the update_annotation.js.erb template' do
        expect(response).to render_template('update_annotation')
      end
    end

    context 'when failed to save annotations' do
      before do
        allow(controller).to receive(:set_annotation).and_return({})
        allow(AnnotatedImage).to receive(:valid_annotations?).and_return(true)
        allow_any_instance_of(AnnotatedImage).to receive(:save).and_return(false)
        post :update_annotation, params: { id: annotated_image.id }, format: :js
      end

      it 'sets flash alert message' do
        expect(flash[:alert]).to eq('Failed to update annotations.')
      end

      it 'renders the update_annotation.js.erb template' do
        expect(response).to render_template('update_annotation')
      end
    end
  end


    # it 'renders the new template if image name is empty' do
    #   post :update, params: { name: '', image: nil }
    #   expect(response).to render_template(:new)
    # end

    # it 'renders the new template if image is not attached' do
    #   post :create, params: { name: 'image-name', image: nil }
    #   expect(response).to render_template(:new)
    # end
    # it 'renders the new template if image attached is not supported' do
    #   post :create, params: { name: 'image-name', image: fixture_file_upload('sample.pdf') }
    #   expect(response).to render_template(:new)
    # end
  end
end
