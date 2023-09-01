class AddNameToAnnotatedImage < ActiveRecord::Migration[6.0]
  def change
    add_column :annotated_images, :name, :string
  end
end
