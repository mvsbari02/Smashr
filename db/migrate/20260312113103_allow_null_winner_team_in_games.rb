class AllowNullWinnerTeamInGames < ActiveRecord::Migration[8.0]
  def change
    change_column_null :games, :winner_team_id, true
  end
end
