class CreateFamilyBonds < ActiveRecord::Migration
  def change
    create_table :family_bonds do |t|
      t.integer :family_member_one_id
      t.integer :family_member_two_id

      t.timestamps null: false
    end
  end
end
