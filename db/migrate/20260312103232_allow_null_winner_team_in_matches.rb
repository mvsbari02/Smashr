class AllowNullWinnerTeamInMatches < ActiveRecord::Migration[8.0]
  def change
    change_column_null :matches, :winner_team_id, true
  end
end
