class Game < ApplicationRecord
  belongs_to :match
  belongs_to :winner_team, class_name: "Team"

  validates :set_number, presence: true
  validates :winner_team_id, presence: true
  validates :team1_score, presence: true
  validates :team2_score, presence: true
end
