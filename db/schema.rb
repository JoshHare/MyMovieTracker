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

ActiveRecord::Schema[7.1].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actor", primary_key: "actorid", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "genre", primary_key: "genreid", id: :integer, default: -> { "nextval('genres_genreid_seq'::regclass)" }, force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "movie", primary_key: "movieid", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "director", limit: 255
    t.string "tagline", limit: 255
    t.text "overview"
    t.integer "runtime"
    t.integer "year"
    t.float "rating"
  end

  create_table "movieactor", primary_key: "movieactor", id: :serial, force: :cascade do |t|
    t.integer "movieid"
    t.integer "actorid"
  end

  create_table "moviegenre", primary_key: "moviegenreid", id: :serial, force: :cascade do |t|
    t.integer "movieid"
    t.integer "genreid"
  end

  create_table "reviews", primary_key: "reviewid", id: :serial, force: :cascade do |t|
    t.integer "userid"
    t.integer "movieid"
    t.datetime "reviewdate", precision: nil
    t.float "rating"
    t.string "comment", limit: 255
  end

  create_table "seen", primary_key: "seenid", id: :serial, force: :cascade do |t|
    t.integer "userid"
    t.integer "movieid"
    t.datetime "watchdate", precision: nil
  end

  create_table "users", primary_key: "userid", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.string "password", limit: 255
    t.boolean "admin"
  end

  add_foreign_key "movieactor", "actor", column: "actorid", primary_key: "actorid", name: "movieactor_actorid_fkey"
  add_foreign_key "movieactor", "movie", column: "movieid", primary_key: "movieid", name: "movieactor_movieid_fkey"
  add_foreign_key "moviegenre", "genre", column: "genreid", primary_key: "genreid", name: "moviegenre_genreid_fkey"
  add_foreign_key "moviegenre", "movie", column: "movieid", primary_key: "movieid", name: "moviegenre_movieid_fkey"
  add_foreign_key "reviews", "movie", column: "movieid", primary_key: "movieid", name: "reviews_movieid_fkey"
  add_foreign_key "reviews", "users", column: "userid", primary_key: "userid", name: "reviews_userid_fkey"
  add_foreign_key "seen", "movie", column: "movieid", primary_key: "movieid", name: "seen_movieid_fkey"
  add_foreign_key "seen", "users", column: "userid", primary_key: "userid", name: "seen_userid_fkey"
end
