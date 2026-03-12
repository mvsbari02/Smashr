class Match < ApplicationRecord
  belongs_to :team1, class_name: "Team"
  belongs_to :team2, class_name: "Team"
  belongs_to :winner_team, class_name: "Team", optional: true
  has_many :games, dependent: :destroy
  accepts_nested_attributes_for :games

  enum :match_type, {
    singles: 0,
    doubles: 1
  }

  validate :teams_must_be_different
  validates :started_at, presence: true
  # validates :ended_at, presence: true
  validates :match_type, presence: true
  validate :teams_must_be_valid_for_match_type
  validate :start_time_must_be_in_future, on: :create

  private

  def teams_must_be_different
    if team1_id == team2_id
      errors.add(:team2, "must be different from team1")
    end
  end

  def teams_must_be_valid_for_match_type
    if match_type == "singles"
      if team1.players.count != 1
        errors.add(:team1, "must have exactly 1 player for singles matches")
      end
      if team2.players.count != 1
        errors.add(:team2, "must have exactly 1 player for singles matches")
      end
    elsif match_type == "doubles"
      if team1.players.count != 2
        errors.add(:team1, "must have exactly 2 players for doubles matches")
      end
      if team2.players.count != 2
        errors.add(:team2, "must have exactly 2 players for doubles matches")
      end
    end
  end

  def start_time_must_be_in_future
    return if started_at.blank?

    if started_at <= Time.current
      errors.add(:started_at, "must be in the future")
    end
  end
end
