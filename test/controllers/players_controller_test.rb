require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = Player.create!(
      name: "Test Player",
      email: "test@example.com",
      country: "India",
      status: :active,
    )
  end

  # GET /players
  test "should get index" do
    get players_path
    assert_response :success
    assert_select "h1", "Players List"
    assert_select "td", @player.name
  end

  # GET /players/new
  test "should get new" do
    get new_player_path
    assert_response :success
    assert_select "h1", "New Player"
  end

  # POST /players with valid data
  test "should create player with valid attributes" do
    assert_difference("Player.count", 1) do
      post players_path, params: {
        player: {
          name: "New Player",
          email: "new@example.com",
          country: "USA",
          status: :active,
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to players_path
    follow_redirect!
    assert_select "td", "New Player"
  end

  # POST /players with invalid data
  test "should not create player with invalid attributes" do
    assert_no_difference("Player.count") do
      post players_path, params: {
        player: {
          name: "", # invalid
          email: "",
          country: "",
          status: "",
          password: "pass",
          password_confirmation: "mismatch"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_player_path(@player)
    assert_response :success
    assert_select "h1", "Edit Player"
  end

  test "should update player with valid attributes" do
    patch player_path(@player), params: {
      player: {
        name: "Updated Name"
      }
    }

    assert_redirected_to players_path
    @player.reload
    assert_equal "Updated Name", @player.name
  end

  test "should destroy player" do
    assert_difference("Player.count", -1) do
      delete player_path(@player)
    end

    assert_redirected_to players_path
  end
end
