class Game < ApplicationRecord
  belongs_to :match
  belongs_to :winner_team
end
