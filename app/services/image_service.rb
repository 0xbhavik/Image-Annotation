class ImageService
  attr_reader :image, :response, :errors

  def initialize(params = nil, image = nil)
    @image = if image.nil?
               AnnotatedImage.new
             else
               image
             end
    unless params.nil?
      @image_name = params[:name] if params[:name].present?
      @image_file = params[:image] if params[:image].present?
      @custom_keys = params[:custom_keys] if params[:custom_keys].present?
      @custom_values = params[:custom_values] if params[:custom_values].present?
    end
    @response = nil
    @errors = []
  end

  def create_image
    if keys_present_and_not_unique?
      @errors << 'Keys must be unique'
    else
      handle_image_creation
    end
  end

  def update_image
    create_image
  end

  def delete_image
    if @image.destroy
      @response = 'Image is deleted successfully'
    else
      @errors << 'Failed to delete image'
    end
  end

  def update_image_annotation
    if keys_present_and_not_unique?
      @errors << 'Keys must be unique'
    else
      @image.annotations = set_annotation
      @errors << 'annotations must be less than 10' if @image.annotations.count > 10
      @errors << 'Keys and values must be present' unless AnnotatedImage.valid_annotations?(@image.annotations)
      return unless @errors.count.zero?

      if @image.save
        @response = 'Annotations are successfully updated'
      else
        @errors << 'Failed to save annotations'
      end
    end
  end

  def keys_present_and_not_unique?
    @custom_keys.present? && @custom_keys.uniq.length != @custom_keys.length
  end

  def handle_image_creation
    @image.annotations = set_annotation
    @image.image = @image_file if @image_file.present?
    @image.name = @image_name if @image_name.present?
  
    handle_errors
    return unless @errors.count.zero?

    if @image.save
      @response = 'Image was successfully uploaded.'
    else
      @errors << 'Failed to save image'
    end
  end

  def handle_errors
    @errors << 'Image name cannot be empty' unless @image.name.present?
    @errors << 'Image is not attached' unless @image.image.attached?
    @errors << 'Only image files (jpg, jpeg, png, gif) are allowed' unless AnnotatedImage.image_valid?(@image)
    @errors << 'annotations must be less than 10' if @image.annotations.count > 10
    @errors << 'Keys and values must be present' unless AnnotatedImage.valid_annotations?(@image.annotations)
  end

  def set_annotation
    annotations = {}
    if @custom_keys.present?
      @custom_keys.each_with_index do |key, index|
        annotations[key] = @custom_values[index]
      end
    end
    annotations
  end
end
