class TeamPlayer < ApplicationRecord
  belongs_to :team
  belongs_to :player

  validate :player_must_be_active

  private

  def player_must_be_active
    unless player.active?
      errors.add(:player, "must be active to be added to a team")
    end
  end
end
