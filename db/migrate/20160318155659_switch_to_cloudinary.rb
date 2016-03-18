class SwitchToCloudinary < ActiveRecord::Migration
  def change
    remove_column :pins, :image_file_name, :string
    remove_column :pins, :image_content_type, :string
    remove_column :pins, :image_file_size, :string
    remove_column :pins, :image_updated_at, :string
    add_column :pins, :public_id, :string
  end
end
