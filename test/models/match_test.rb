require "test_helper"

class MatchTest < ActiveSupport::TestCase
  def setup
    @team1 = Team.create!(name: "Team A")
    @team2 = Team.create!(name: "Team B")

    @player1 = Player.create!(
      name: "Player 1",
      email: "p1@example.com",
      country: "India",
      status: :active
    )

    @player2 = Player.create!(
      name: "Player 2",
      email: "p2@example.com",
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

  def build_match(attributes = {})
    Match.new(
      {
        team1: @team1,
        team2: @team2,
        match_type: :singles,
        started_at: 10.minutes.from_now,
        ended_at: 40.minutes.from_now,
        best_of: 3
      }.merge(attributes)
    )
  end

  test "team1 and team2 must be different" do
    match = build_match(
      team1: @team1,
      team2: @team1
    )

    assert_not match.valid?
    assert_includes match.errors[:team2], "must be different from team1"
  end

  test "match is valid when teams are different" do
    match = build_match

    assert match.valid?, match.errors.full_messages.join(", ")
  end

  test "match should be valid with all required fields" do
    match = build_match

    assert match.valid?, match.errors.full_messages.join(", ")
  end

  test "should not save match without match_type" do
    match = build_match(match_type: nil)

    assert_not match.valid?
    assert_includes match.errors[:match_type], "can't be blank"
  end

  test "should not save match without best_of" do
    match = build_match(best_of: nil)

    assert_not match.valid?
    assert_includes match.errors[:best_of], "can't be blank"
  end

  test "should not save match when started_at is not in the future on create" do
    match = build_match(started_at: Time.current)

    assert_not match.valid?
    assert_includes match.errors[:started_at], "must be in the future"
  end

  test "match is invalid when ended_at is before started_at" do
    match = build_match(
      started_at: 1.hour.from_now,
      ended_at: 30.minutes.from_now
    )

    assert_not match.valid?
    assert_includes match.errors[:ended_at], "must be greater than started at"
  end

  test "match is invalid when ended_at equals started_at" do
    time = 1.hour.from_now
    match = build_match(
      started_at: time,
      ended_at: time
    )

    assert_not match.valid?
    assert_includes match.errors[:ended_at], "must be greater than started at"
  end

  test "match is valid when ended_at is after started_at" do
    match = build_match(
      started_at: 1.hour.from_now,
      ended_at: 2.hours.from_now
    )

    assert match.valid?, match.errors.full_messages.join(", ")
  end

  # this test will be added after game creation logic is moved out of controller
  # test "match is invalid when winner team is selected but not all games have winners" do
  #   @match.games.find_by(set_number: 1)&.update!(
  #     team1_score: 21,
  #     team2_score: 18,
  #     winner_team: @team1
  #   )

  #   @match.games.find_by(set_number: 2)&.update!(
  #     team1_score: nil,
  #     team2_score: nil,
  #     winner_team: nil
  #   )

  #   @match.games.find_by(set_number: 3)&.update!(
  #     team1_score: nil,
  #     team2_score: nil,
  #     winner_team: nil
  #   )

  #   @match.winner_team = @team1

  #   assert_not @match.valid?
  #   assert_includes @match.errors[:winner_team],
  #                   "cannot be selected until all games have winners. Incomplete games: 2, 3"
  # end

  test "match is valid when winner team is selected and all games have winners" do
    @match.games.find_by(set_number: 1)&.update!(
      team1_score: 21,
      team2_score: 18,
      winner_team: @team1
    )

    @match.games.find_by(set_number: 2)&.update!(
      team1_score: 18,
      team2_score: 21,
      winner_team: @team2
    )

    @match.games.find_by(set_number: 3)&.update!(
      team1_score: 21,
      team2_score: 19,
      winner_team: @team1
    )

    @match.winner_team = @team1
    @match.ended_at = 2.hours.from_now

    assert @match.valid?, @match.errors.full_messages.join(", ")
  end
end