class Game < ApplicationRecord
  belongs_to :match
  belongs_to :winner_team, class_name: "Team", optional: true

  validates :set_number, presence: true
  validates :winner_team_id, presence: true, if: :game_completed?
  validates :team1_score, presence: true, if: :game_completed?
  validates :team2_score, presence: true, if: :game_completed?
  validate :score_validations, if: :game_completed?
  validate :winner_team_must_match_higher_score, if: :game_completed?


  private

  def score_validations
    return if team1_score.blank? || team2_score.blank? || winner_team_id.blank?

    score1 = team1_score
    score2 = team2_score

    if score1 > 30 || score2 > 30
      add_game_error("Score of either team cannot be more than 30")
      return
    end

    if score1 == score2
      add_game_error("Game cannot end in a tie")
      return
    end

    winner_score = [score1, score2].max
    loser_score  = [score1, score2].min
    difference   = winner_score - loser_score

    if loser_score < 20 && winner_score != 21
      add_game_error("Winner score must be exactly 21 when opponent has less than 20")
      return
    end

    if winner_score == 30 && loser_score == 29
      return
    end

    unless difference >= 2
      add_game_error("There must be at least a 2-point difference unless the score is 30-29")
    end
  end

  def add_game_error(message)
    errors.add(:base, "Game #{set_number}: #{message}")
  end

  def winner_team_must_match_higher_score
    return if team1_score.blank? || team2_score.blank? || winner_team_id.blank?

    if team1_score > team2_score && winner_team_id != match.team1_id
      add_game_error("Winner team must be Team 1 because Team 1 has the higher score")
    elsif team2_score > team1_score && winner_team_id != match.team2_id
      add_game_error("Winner team must be Team 2 because Team 2 has the higher score")
    end
  end

  def game_completed?
    team1_score.present? || team2_score.present? || winner_team_id.present?
  end
end
