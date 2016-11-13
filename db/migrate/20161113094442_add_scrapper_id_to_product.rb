class AddScrapperIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :scrapper_id, :integer
  end
end
