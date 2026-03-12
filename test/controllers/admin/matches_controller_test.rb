require "test_helper"

class Admin::MatchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @team1 = Team.create!(name: "Team A")
    @team2 = Team.create!(name: "Team B")

    @player1 = Player.create!(
      name: "Player 1",
      email: "player1@example.com",
      country: "India",
      status: :active
    )

    @player2 = Player.create!(
      name: "Player 2",
      email: "player2@example.com",
      country: "India",
      status: :active
    )

    TeamPlayer.create!(team: @team1, player: @player1)
    TeamPlayer.create!(team: @team2, player: @player2)

    @match = Match.create!(
      team1: @team1,
      team2: @team2,
      match_type: :singles,
      started_at: 10.minutes.from_now,
      best_of: 3
    )
  end

  test "should get index" do
    get admin_matches_path
    assert_response :success
  end

  test "should get new" do
    get new_admin_match_path
    assert_response :success
  end

  test "should create match with valid attributes" do
    team3 = Team.create!(name: "Team C")
    team4 = Team.create!(name: "Team D")

    player3 = Player.create!(
      name: "Player 3",
      email: "player3@example.com",
      country: "India",
      status: :active
    )

    player4 = Player.create!(
      name: "Player 4",
      email: "player4@example.com",
      country: "India",
      status: :active
    )

    TeamPlayer.create!(team: team3, player: player3)
    TeamPlayer.create!(team: team4, player: player4)

    assert_difference("Match.count", 1) do
      assert_difference("Game.count", 3) do
        post admin_matches_path, params: {
          match: {
            team1_id: team3.id,
            team2_id: team4.id,
            match_type: :singles,
            started_at: 20.minutes.from_now,
            best_of: 3
          }
        }
      end
    end

    assert_redirected_to admin_matches_path
  end

  test "should not create match with invalid attributes" do
    assert_no_difference("Match.count") do
      post admin_matches_path, params: {
        match: {
          team1_id: @team1.id,
          team2_id: @team1.id,
          match_type: :singles,
          started_at: 10.minutes.ago,
          best_of: nil
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_admin_match_path(@match)
    assert_response :success
  end

  test "should update match with valid attributes" do
    patch admin_match_path(@match), params: {
      match: {
        ended_at: 1.hour.from_now,
        winner_team_id: @team1.id
      }
    }

    assert_redirected_to admin_matches_path
    @match.reload
    assert_equal @team1.id, @match.winner_team_id
  end

  test "should destroy match" do
    assert_difference("Match.count", -1) do
      delete admin_match_path(@match)
    end

    assert_redirected_to admin_matches_path
  end
end
