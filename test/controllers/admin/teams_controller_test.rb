require "test_helper"

class Admin::TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = Team.create!(name: "Team A")
  end

  test "should get index" do
    get admin_teams_path
    assert_response :success
    assert_select "h2", "Teams List"
    assert_select "td", @team.name
  end

  test "should get new" do
    get new_admin_team_path
    assert_response :success
    assert_select "h2", "New Team"
  end

  test "should create team with valid attributes" do
    assert_difference("Team.count", 1) do
      post admin_teams_path, params: {
        team: {
          name: "Team B"
        }
      }
    end

    assert_redirected_to admin_teams_path
  end

  test "should not create team with invalid attributes" do
    assert_no_difference("Team.count") do
      post admin_teams_path, params: {
        team: {
          name: ""
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_admin_team_path(@team)
    assert_response :success
    assert_select "h2", "Edit Team"
  end

  test "should update team with valid attributes" do
    patch admin_team_path(@team), params: {
      team: {
        name: "Updated Team"
      }
    }

    assert_redirected_to admin_teams_path
    @team.reload
    assert_equal "Updated Team", @team.name
  end

  test "should destroy team" do
    assert_difference("Team.count", -1) do
      delete admin_team_path(@team)
    end

    assert_redirected_to admin_teams_path
  end
end
