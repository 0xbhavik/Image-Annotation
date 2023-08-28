class AnnotatedImagesController < ApplicationController
  before_action :set_image, only: %i[edit update show destroy update_annotation]
  before_action :set_prev_and_next_image, only: [:show]

  def index
    @annotated_images = AnnotatedImage.paginate(page: params[:page], per_page: 10)
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
    elsif !AnnotatedImage.valid_annotations? @image.annotations
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
    @image.image = params[:image] if params[:image]
    if !valid_annotations? @image.annotations
      flash[:alert] = 'annotations are not valid'
      redirect_to edit_annotated_image_path(@image)
    elsif @image.update(image_params)
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
    if !AnnotatedImage.valid_annotations? @image.annotations
      respond_to do |format|
        format.js { flash.now[:alert] = 'Failed to update annotations.' }
      end
    elsif @image.save
      respond_to do |format|
        format.js { flash.now[:notice] = 'Annotations updated successfully.' }
      end
    else
      respond_to do |format|
        format.js { flash.now[:alert] = 'Failed to update annotations.' }
      end
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
    if params[:custom_keys] && params[:custom_values] && !params[:custom_keys].empty?
      custom_keys = params[:custom_keys]
      custom_values = params[:custom_values]
      custom_keys.zip(custom_values).to_h
    else
      annotations = {}
      annotations
    end
  end

  def image_valid?
    allowed_types = ['image/jpeg', 'image/png', 'image/gif']
    @image.image.content_type.in?(allowed_types)
  end


end
