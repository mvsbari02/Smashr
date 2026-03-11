require "test_helper"

class Admin::TeamsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_teams_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_teams_create_url
    assert_response :success
  end

  test "should get index" do
    get admin_teams_index_url
    assert_response :success
  end

  test "should get edit" do
    get admin_teams_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_teams_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_teams_destroy_url
    assert_response :success
  end
end
