class RenameTitreColumnT < ActiveRecord::Migration[5.1]
  def change
    rename_column :registrations, :listing_content, :listing_title
  end
end
