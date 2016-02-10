class CreatePinsUser < ActiveRecord::Migration
  def change
    create_table :pins_users do |t|
      t.integer :user_id
      t.integer :pin_id
    end
  end
end
