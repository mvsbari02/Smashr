class Game < ApplicationRecord
  belongs_to :match
  belongs_to :winner_team, class_name: "Team", optional: true

  validates :set_number, presence: true
  validates :winner_team_id, presence: true, if: :game_completed?
  validates :team1_score, presence: true, if: :game_completed?
  validates :team2_score, presence: true, if: :game_completed?


  private

  def game_completed?
    team1_score.present? || team2_score.present? || winner_team_id.present?
  end
end
