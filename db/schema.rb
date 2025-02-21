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

ActiveRecord::Schema[7.1].define(version: 2025_02_13_224334) do
  create_table "flows", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_42038c5d78"
  end

  create_table "parts", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "tag"
    t.string "hiringCompany"
    t.string "image"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "flow_id", null: false
    t.index ["flow_id"], name: "fk_rails_4e346bfec1"
    t.index ["user_id"], name: "fk_rails_f85f1811f0"
  end

  create_table "steps", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "startDate"
    t.datetime "finishDate"
    t.string "image"
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "flow_id", null: false
    t.index ["flow_id"], name: "fk_rails_dd10677e21"
    t.index ["user_id"], name: "index_steps_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "fullName", null: false
    t.bigint "cnpj", null: false
    t.string "email", null: false
    t.string "image"
    t.integer "cityId"
    t.integer "stateId"
    t.string "address"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "flows", "users"
  add_foreign_key "parts", "flows"
  add_foreign_key "parts", "users"
  add_foreign_key "steps", "flows"
  add_foreign_key "steps", "users"
end
