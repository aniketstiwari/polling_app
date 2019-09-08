class ChangeColumnInRestaurants < ActiveRecord::Migration[5.2]
  def change
    rename_column :restaurants, :image_url, :attachment
  end
end
