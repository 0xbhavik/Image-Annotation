class AnnotatedImagesController < ApplicationController
  before_action :set_image, only: %i[edit update show destroy update_annotation edit_annotation]
  before_action :set_prev_and_next_image, only: [:show]

  def index
    @annotated_images = AnnotatedImage.all
  end

  def create
    @image = AnnotatedImage.new(image_params)
    @image.annotations = set_annotation
    @image.image = params[:image] if params[:image].present?
    if handle_errors
      render :new
    elsif @image.save
      redirect_to annotated_images_path, notice: 'Image was successfully uploaded.'
    else
      flash[:alert] = 'Failed to save image'
      render :new
    end
  end

  def update
    @image.annotations = set_annotation
    @image.image = params[:image] if params[:image].present?

    if handle_errors
      render :edit
    else
      @image.update(image_params)
      flash[:notice] = 'image is updated successfully.'
      redirect_to annotated_images_path
    end
  end

  def update_annotation
    @image.annotations = set_annotation
    if !AnnotatedImage.valid_annotations? @image.annotations
      respond_to do |format|
        format.js { flash.now[:alert] = 'Keys and values must be present' }
      end
    else
      @image.save
      respond_to do |format|
        format.js { flash.now[:notice] = 'Annotations updated successfully.' }
      end
    end
  end

  def destroy
    if @image.destroy
      redirect_to annotated_images_path, notice: 'Image was successfully deleted.'
    else
      render :index
      flash[:alert] = 'Failed to delete image'
    end
  end

  def edit_annotation; end

  def show; end

  def edit; end

  private

  def handle_errors
    if @image.name.empty?
      flash[:alert] = 'Image name cannot be empty'
      return true
    end

    unless @image.image.attached?
      flash[:alert] = 'Image is not attached'
      return true
    end
    unless AnnotatedImage.image_valid?(@image)
      flash[:alert] = 'Only image files (jpg, jpeg, png, gif) are allowed'
      return true
    end
    if @image.annotations.count > 10
      flash[:alert] = 'annotations must be less than 10'
      return true
    end
    unless AnnotatedImage.valid_annotations?(@image.annotations)
      flash[:alert] = 'Keys and values must be present'
      return true
    end

    false
  end

  def image_params
    params.permit(:name)
  end

  def set_image
    @image = AnnotatedImage.find(params[:id])
  end

  def set_annotation
    if params[:custom_keys] && params[:custom_values] && !params[:custom_keys].empty?
      custom_keys = params[:custom_keys]
      custom_values = params[:custom_values]
      custom_keys.zip(custom_values).to_h
    else
      {}.to_h
    end
  end
end
