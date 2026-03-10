require "test_helper"

class MatchTest < ActiveSupport::TestCase
  def setup
    @team1 = Team.create!(name: "Team A")
    @team2 = Team.create!(name: "Team B")
  end

  test "team1 and team2 must be different" do
    match = Match.new(
      team1: @team1,
      team2: @team1,
      match_type: :singles,
      winner_team: @team1
    )

    assert_not match.valid?
    assert_includes match.errors[:team2], "must be different from team1"
  end

  test "match is valid when teams are different" do
    match = Match.new(
      team1: @team1,
      team2: @team2,
      winner_team: @team1,
      match_type: :singles,
      started_at: Time.current,
      ended_at: Time.current + 30.minutes
    )

    assert match.valid?
  end

  test "should not save match without ended_at" do
    match = Match.new(
      team1: @team1,
      team2: @team2,
      winner_team: @team1,
      match_type: :singles,
      started_at: Time.current
    )

    assert_not match.valid?
    assert_includes match.errors[:ended_at], "can't be blank"
  end

  test "match should be valid with all required fields" do
    match = Match.new(
      team1: @team1,
      team2: @team2,
      match_type: :singles,
      winner_team: @team1,
      started_at: Time.current,
      ended_at: Time.current + 30.minutes
    )

    assert match.valid?
  end

  test "should not save match without match_type" do
    match = Match.new(
      team1: @team1,
      team2: @team2,
      winner_team: @team1,
      started_at: Time.current,
      ended_at: Time.current + 30.minutes
    )

    assert_not match.valid?
    assert_includes match.errors[:match_type], "can't be blank"
  end
end
