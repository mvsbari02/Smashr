class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.references :match, null: false, foreign_key: true
      t.integer :set_number
      t.integer :team1_score
      t.integer :team2_score
      t.references :winner_team, null: false, foreign_key: { to_table: :teams }
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
