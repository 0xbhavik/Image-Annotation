class AnnotatedImagesController < ApplicationController
  before_action :set_image, only: %i[edit update show destroy update_annotation]
  before_action :set_prev_and_next_image, only: [:show]

  def index
    @annotated_images = AnnotatedImage.paginate(page: params[:page], per_page: 2)
  end

  def create
    @image = AnnotatedImage.new(image_params)
    @image.annotations = set_annotation
    if !@image.image.attached?
      flash[:alert] = 'image is not attached'
      redirect_to new_annotated_image_path
    elsif !image_valid?
      flash[:alert] = 'Only image files (jpg, jpeg, png, gif) are allowed'
      redirect_to new_annotated_image_path
    elsif !valid_annotations? @image.annotations
      flash[:alert] = 'annotations are not valid'
      redirect_to new_annotated_image_path
    elsif @image.save
      redirect_to annotated_images_path, notice: 'Image was successfully uploaded.'
    else
      flash[:alert] = 'Failed to save image'
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    @image.annotations = set_annotation
    if !valid_annotations? @image.annotations
      flash[:alert] = 'annotations are not valid'
      redirect_to edit_annotated_image_path(@image)
    elsif @image.save
      flash[:notice] = 'image is updated successfully.'
      redirect_to annotated_images_path
    else
      flash[:alert] = 'not updated'
      redirect_to edit_annotated_image_path(@image)
    end
  end

  def destroy
    @image.destroy
    redirect_to annotated_images_path
  end

  def update_annotation
    @image.annotations = set_annotation
    if !valid_annotations? @image.annotations
      flash[:alert] = 'annotations are not valid'
      redirect_to edit_annotated_images_path(@image)
    elsif @image.save
      respond_to do |format|
      format.js { render partial: 'annotated_images/update_annotation' }
      end
    else
      flash[:alert] = 'not updated'
      redirect_to edit_annotated_images_path
    end
  end

  private

  def image_params
    params.permit(:name, :image)
  end

  def set_prev_and_next_image
    @prev_image = AnnotatedImage.where('id < ?', @image.id).last
    @prev_image ||= AnnotatedImage.last
    @next_image = AnnotatedImage.where('id > ?', @image.id).first
    @next_image ||= AnnotatedImage.first
  end

  def set_image
    @image = AnnotatedImage.find(params[:id])
  end

  def set_annotation
    custom_keys = params[:custom_keys]
    custom_values = params[:custom_values]
    custom_keys.zip(custom_values).to_h
  end

  def image_valid?
    allowed_types = ['image/jpeg', 'image/png', 'image/gif']
    @image.image.content_type.in?(allowed_types)
  end

  def valid_annotations?(annotations)
    annotations.each do |key, value|
      return false if (key.empty? && !value.empty?) || (value.empty? && !key.empty?)
    end
    true
  end
end
