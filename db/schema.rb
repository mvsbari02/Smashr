# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_03_10_140923) do
  create_table "admin_users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "set_number"
    t.integer "team1_score"
    t.integer "team2_score"
    t.integer "winner_team_id", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_games_on_match_id"
    t.index ["winner_team_id"], name: "index_games_on_winner_team_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "type"
    t.integer "team1_id", null: false
    t.integer "team2_id", null: false
    t.integer "winner_team_id", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "best_of"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team1_id"], name: "index_matches_on_team1_id"
    t.index ["team2_id"], name: "index_matches_on_team2_id"
    t.index ["winner_team_id"], name: "index_matches_on_winner_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "country"
    t.integer "matches"
    t.integer "wins"
    t.integer "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
  end

  create_table "team_players", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_team_players_on_player_id"
    t.index ["team_id"], name: "index_team_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "games", "matches"
  add_foreign_key "games", "teams", column: "winner_team_id"
  add_foreign_key "matches", "teams", column: "team1_id"
  add_foreign_key "matches", "teams", column: "team2_id"
  add_foreign_key "matches", "teams", column: "winner_team_id"
  add_foreign_key "team_players", "players"
  add_foreign_key "team_players", "teams"
end
