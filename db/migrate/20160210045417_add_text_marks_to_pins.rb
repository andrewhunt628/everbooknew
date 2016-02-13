class AddTextMarksToPins < ActiveRecord::Migration
  def change
    add_column :pins, :text_marks, :text
  end
end
