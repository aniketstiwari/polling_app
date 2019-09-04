class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.binary :vote, default: 0
      t.timestamps
    end
  end
end
