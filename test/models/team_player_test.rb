require "test_helper"

class TeamPlayerTest < ActiveSupport::TestCase
  # test "player must be active to join a team" do
  #   team = Team.create!(name: "Team A")

  #   player = Player.create!(
  #     name: "John",
  #     email: "john@example.com",
  #     country: "India",
  #     status: :beta_active
  #   )

  #   team_player = TeamPlayer.new(team: team, player: player)

  #   assert_not team_player.valid?
  #   assert_includes team_player.errors[:player], "must be active to be added to a team"
  end
end
