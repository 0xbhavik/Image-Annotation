require_relative '../services/image_service'

class AnnotatedImagesController < ApplicationController
  before_action :set_image, only: %i[edit update destroy update_annotation edit_annotation]

  def index
    @annotated_images = AnnotatedImage.paginate(page: params[:page], per_page: 2)
  end

  def create
    image_service = ImageService.new(permitted_params)
    image_service.create_image
    
    if image_service.response.present?
      redirect_to annotated_images_path, notice: image_service.response
    else
      flash[:alert] = image_service.errors.join('<br/>').html_safe
      render :new
    end
  end

  def update
    image_service = ImageService.new(permitted_params, @image)
    image_service.update_image
    if image_service.response.present?
      respond_to do |format|
        format.js { flash.now[:notice] = image_service.response }
        format.html { redirect_to annotated_images_path, notice: image_service.response }
      end
    else
      respond_to do |format|
        format.js { flash[:alert] = image_service.errors.join('<br/>').html_safe }
        format.html do 
          flash[:alert] = image_service.errors.join('<br/>').html_safe 
          render :edit
        end
      end
    end
  end

  def destroy
    image_service = ImageService.new(nil, @image)
    image_service.delete_image

    if image_service.response.present?
      redirect_to annotated_images_path, notice: image_service.response
    else
      flash[:alert] = image_service.errors.join('<br/>').html_safe
      render :index
    end
  end

  def edit_annotation; end

  def edit; end

  def load_images
    @next_images = AnnotatedImage.paginate(page: params[:page], per_page: 2)
    respond_to do |format|
      format.js
    end
  end

  private

  def set_image
    @image = AnnotatedImage.find(params[:id])
  end

  def permitted_params
    params.permit(:name, :image, custom_keys: [], custom_values: [])
  end
end
