require "test_helper"

class GameTest < ActiveSupport::TestCase
  def setup
    @team1 = Team.create!(name: "Team A")
    @team2 = Team.create!(name: "Team B")
    @match = Match.create!(
      match_type: :singles,
      team1: @team1,
      team2: @team2,
      winner_team: @team1,
      started_at: Time.current,
      ended_at: Time.current + 30.minutes
    )
  end

  test "should not save game without set_number" do
    game = Game.new(
      match: @match,
      winner_team_id: @team1.id,
      team1_score: 21,
      team2_score: 18
    )

    assert_not game.valid?
    assert_includes game.errors[:set_number], "can't be blank"
  end

  test "should not save game without winner_team" do
    game = Game.new(
      match: @match,
      set_number: 1,
      team1_score: 21,
      team2_score: 18
    )

    assert_not game.valid?
    assert_includes game.errors[:winner_team], "must exist"
  end

  test "should not save game without team1_score" do
    game = Game.new(
      match: @match,
      set_number: 1,
      winner_team: @team1,
      team2_score: 18
    )

    assert_not game.valid?
    assert_includes game.errors[:team1_score], "can't be blank"
  end

  test "should not save game without team2_score" do
    game = Game.new(
      match: @match,
      winner_team: @team1,
      set_number: 1,
      team1_score: 21
    )

    assert_not game.valid?
    assert_includes game.errors[:team2_score], "can't be blank"
  end

  test "valid game should be saved" do
    game = Game.new(
      match: @match,
      winner_team: @team1,
      set_number: 1,
      team1_score: 21,
      team2_score: 18
    )

    assert game.valid?
  end
end
