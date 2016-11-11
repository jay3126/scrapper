class AddNameToScrapper < ActiveRecord::Migration
  def change
    add_column :scrappers, :productName, :text
  end
end
