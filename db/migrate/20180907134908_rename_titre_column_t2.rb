class RenameTitreColumnT2 < ActiveRecord::Migration[5.1]
  def change
    rename_column :listings, :listing_title, :listing_content
  end
end
