class RenameTypeToMatchTypeInMatches < ActiveRecord::Migration[8.0]
  def change
    rename_column :matches, :type, :match_type
  end
end
