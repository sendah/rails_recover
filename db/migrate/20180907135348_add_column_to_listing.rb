class AddColumnToListing < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :listing_title, :string
  end
end
