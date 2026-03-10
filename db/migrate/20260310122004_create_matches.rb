class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.integer :type
      t.references :team1, null: false, foreign_key: { to_table: :teams }
      t.references :team2, null: false, foreign_key: { to_table: :teams }
      t.references :winner_team, null: false, foreign_key: { to_table: :teams }
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :best_of

      t.timestamps
    end
  end
end
