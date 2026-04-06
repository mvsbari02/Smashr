class Team < ApplicationRecord
    has_many :team_players, dependent: :destroy
    has_many :players, through: :team_players
    has_many :matches_as_team1, class_name: "Match", foreign_key: "team1_id", dependent: :nullify
    has_many :matches_as_team2, class_name: "Match", foreign_key: "team2_id", dependent: :nullify
    has_many :matches_as_winner, class_name: "Match", foreign_key: "winner_team_id", dependent: :nullify

    validates :name, presence: true, uniqueness: true

    def matches
        Match.where("team1_id = ? OR team2_id = ?", id, id)
    end
end
