class CreateApiKeys < ActiveRecord::Migration
  def up
    create_table :api_keys do |t|
      t.string :apikey,  null: false
      t.date :expired_date, null: false
      t.timestamps null: false
    end

    add_reference :api_keys, :user, index: true, foreign_key: true
  end

  def down
    drop_table :api_keys 
  end
end
