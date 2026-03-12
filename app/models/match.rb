class Match < ApplicationRecord
  belongs_to :team1, class_name: "Team"
  belongs_to :team2, class_name: "Team"
  belongs_to :winner_team, class_name: "Team", optional: true

  enum :match_type, {
    singles: 0,
    doubles: 1
  }

  validate :teams_must_be_different
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :match_type, presence: true

  private

  def teams_must_be_different
    if team1_id == team2_id
      errors.add(:team2, "must be different from team1")
    end
  end
end
