class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.integer :size
      t.string :name
      t.integer :leader_id

      t.timestamps
    end
    add_index :groups, :leader_id
  end
end
