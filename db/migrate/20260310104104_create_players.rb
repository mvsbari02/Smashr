class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :email
      t.string :country
      t.integer :matches
      t.integer :wins
      t.integer :password_digest

      t.timestamps
    end
  end
end
