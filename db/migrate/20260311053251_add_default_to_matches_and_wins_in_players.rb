class AddDefaultToMatchesAndWinsInPlayers < ActiveRecord::Migration[8.0]
  def change
    change_column :players, :matches, :integer, default: 0, null: false
    change_column :players, :wins, :integer, default: 0, null: false
  end
end
