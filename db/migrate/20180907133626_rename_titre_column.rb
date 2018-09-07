class RenameTitreColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :registrations, :listing_title, :listing_content
  end
end
