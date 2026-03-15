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
  validates :best_of, presence: true
  # validates :ended_at, presence: true
  validates :match_type, presence: true
  validate :teams_must_be_valid_for_match_type
  validate :start_time_must_be_in_future, on: :create
  validate :winner_team_requires_all_games_to_have_winners
  validate :ended_at_must_be_after_started_at, if: -> { ended_at.present? && started_at.present? }

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

  def winner_team_requires_all_games_to_have_winners
    return if winner_team_id.blank?

    incomplete_games = games.select { |g| g.winner_team_id.blank? }

    if incomplete_games.any?
      game_numbers = incomplete_games.map(&:set_number).sort.join(", ")
      errors.add(:winner_team,
                "cannot be selected until all games have winners. Incomplete games: #{game_numbers}")
    end
  end

  def ended_at_must_be_after_started_at
    return if started_at.blank? || ended_at.blank?

    if ended_at <= started_at
      errors.add(:ended_at, "must be greater than started at")
    end
  end

  def start_time_must_be_in_future
    return if started_at.blank?

    if started_at <= Time.current
      errors.add(:started_at, "must be in the future")
    end
  end
end
