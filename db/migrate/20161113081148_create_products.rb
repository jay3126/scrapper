class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.float :price
      t.integer :rating
      t.string :cod
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
