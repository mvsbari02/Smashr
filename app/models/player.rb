class Player < ApplicationRecord
    has_many :team_players
    has_many :teams, through: :team_players

    enum :status, {
        active: 0,
        beta_active: 1
    }
end
