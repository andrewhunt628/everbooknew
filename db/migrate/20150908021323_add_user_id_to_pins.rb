class AddUserIdToPins < ActiveRecord::Migration
  def change
    add_column :pins, :userid, :integer
    add_index :pins, :userid
  end
end
