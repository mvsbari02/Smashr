class Match < ApplicationRecord
  belongs_to :team1, class_name: "Team"
  belongs_to :team2, class_name: "Team"
  belongs_to :winner_team, class_name: "Team"
end
