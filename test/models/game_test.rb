require "test_helper"

class GameTest < ActiveSupport::TestCase
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

  def build_game(team1_score: nil, team2_score: nil, winner_team: nil, set_number: 1)
    Game.new(
      match: @match,
      set_number: set_number,
      team1_score: team1_score,
      team2_score: team2_score,
      winner_team: winner_team
    )
  end

  test "should not save game without set_number" do
    game = Game.new(
      match: @match,
      team1_score: 21,
      team2_score: 18,
      winner_team: @team1
    )

    assert_not game.valid?
    assert_includes game.errors[:set_number], "can't be blank"
  end

  test "blank placeholder game is valid when scores and winner are not filled" do
    game = Game.new(
      match: @match,
      set_number: 1
    )

    assert game.valid?, game.errors.full_messages.join(", ")
  end

  test "game is invalid when only winner team is filled without scores" do
    game = Game.new(
      match: @match,
      set_number: 1,
      winner_team: @team1
    )

    assert_not game.valid?
    assert_includes game.errors[:team1_score], "can't be blank"
    assert_includes game.errors[:team2_score], "can't be blank"
  end

  test "game is invalid when only team1 score is filled" do
    game = Game.new(
      match: @match,
      set_number: 1,
      team1_score: 21,
    )

    assert_not game.valid?
    assert_includes game.errors[:team2_score], "can't be blank"
  end

  test "game is invalid when only team2 score is filled" do
    game = Game.new(
      match: @match,
      set_number: 1,
      team2_score: 18,
    )

    assert_not game.valid?
    assert_includes game.errors[:team1_score], "can't be blank"
  end

  test "game is invalid when a score is greater than 30" do
    game = build_game(
      team1_score: 31,
      team2_score: 29,
      winner_team: @team1,
      set_number: 1
    )

    assert_not game.valid?
    assert_includes game.errors[:base], "Game 1: Score of either team cannot be more than 30"
  end

  test "game is invalid when scores are tied" do
    game = build_game(
      team1_score: 20,
      team2_score: 20,
      winner_team: @team1,
      set_number: 1
    )

    assert_not game.valid?
    assert_includes game.errors[:base], "Game 1: Game cannot end in a tie"
  end

  test "game is invalid when loser score is below 20 and winner score is greater than 21" do
    game = build_game(
      team1_score: 22,
      team2_score: 19,
      winner_team: @team1,
      set_number: 1
    )

    assert_not game.valid?
    assert_includes game.errors[:base], "Game 1: Winner score must be exactly 21 when opponent has less than 20"
  end

  test "game is valid when score is 21-19" do
    game = build_game(
      team1_score: 21,
      team2_score: 19,
      winner_team: @team1,
      set_number: 1
    )

    assert game.valid?, game.errors.full_messages.join(", ")
  end

  test "game is invalid when there is only 1 point difference before 30-29" do
    game = build_game(
      team1_score: 21,
      team2_score: 20,
      winner_team: @team1,
      set_number: 2
    )

    assert_not game.valid?
    assert_includes game.errors[:base], "Game 2: There must be at least a 2-point difference unless the score is 30-29"
  end

  test "game is valid when there is a 2 point difference after deuce" do
    game = build_game(
      team1_score: 22,
      team2_score: 20,
      winner_team: @team1,
      set_number: 2
    )

    assert game.valid?, game.errors.full_messages.join(", ")
  end

  test "game is valid for 30-29 special case" do
    game = build_game(
      team1_score: 30,
      team2_score: 29,
      winner_team: @team1,
      set_number: 3
    )

    assert game.valid?, game.errors.full_messages.join(", ")
  end

  test "game is invalid for 29-28 because 1 point difference is not allowed" do
    game = build_game(
      team1_score: 29,
      team2_score: 28,
      winner_team: @team1,
      set_number: 3
    )

    assert_not game.valid?
    assert_includes game.errors[:base], "Game 3: There must be at least a 2-point difference unless the score is 30-29"
  end

  test "game is invalid when winner team does not match higher score for team1 win" do
    game = build_game(
      team1_score: 21,
      team2_score: 18,
      winner_team: @team2,
      set_number: 1
    )

    assert_not game.valid?
    assert_includes game.errors[:base], "Game 1: Winner team must be Team 1 because Team 1 has the higher score"
  end

  test "game is invalid when winner team does not match higher score for team2 win" do
    game = build_game(
      team1_score: 18,
      team2_score: 21,
      winner_team: @team1,
      set_number: 2
    )

    assert_not game.valid?
    assert_includes game.errors[:base], "Game 2: Winner team must be Team 2 because Team 2 has the higher score"
  end

  test "game is valid when winner team matches higher score for team1 win" do
    game = build_game(
      team1_score: 21,
      team2_score: 18,
      winner_team: @team1,
      set_number: 1
    )

    assert game.valid?, game.errors.full_messages.join(", ")
  end

  test "game is valid when winner team matches higher score for team2 win" do
    game = build_game(
      team1_score: 18,
      team2_score: 21,
      winner_team: @team2,
      set_number: 2
    )

    assert game.valid?, game.errors.full_messages.join(", ")
  end
end
