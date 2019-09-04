class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.string :event_type
      t.datetime :start_date
      t.datetime :end_date
      t.string :is_expire, default: 'false'

      t.timestamps
    end
  end
end
