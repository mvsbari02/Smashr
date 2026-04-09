class Player < ApplicationRecord
    has_many :team_players
    has_many :teams, through: :team_players

    enum :status, {
        active: 0,
        beta_active: 1
    }

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :country, presence: true

    def losses
        matches - wins
    end
end
