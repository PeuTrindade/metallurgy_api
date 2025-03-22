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

ActiveRecord::Schema[7.1].define(version: 2025_03_22_121559) do
  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", charset: "utf8mb3", force: :cascade do |t|
    t.text "description"
    t.bigint "user_id", null: false
    t.bigint "flow_id", null: false
    t.bigint "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flow_id"], name: "index_comments_on_flow_id"
    t.index ["part_id"], name: "index_comments_on_part_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "flows", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_42038c5d78"
  end

  create_table "inspections", charset: "utf8mb3", force: :cascade do |t|
    t.string "image"
    t.text "description", null: false
    t.bigint "user_id", null: false
    t.bigint "flow_id", null: false
    t.bigint "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flow_id"], name: "index_inspections_on_flow_id"
    t.index ["part_id"], name: "index_inspections_on_part_id"
    t.index ["user_id"], name: "index_inspections_on_user_id"
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
    t.text "description"
    t.index ["flow_id"], name: "fk_rails_4e346bfec1"
    t.index ["user_id"], name: "fk_rails_f85f1811f0"
  end

  create_table "steps", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "startDate"
    t.datetime "finishDate"
    t.string "image"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "flow_id", null: false
    t.bigint "part_id"
    t.index ["flow_id"], name: "fk_rails_dd10677e21"
    t.index ["part_id"], name: "fk_rails_436fe79681"
    t.index ["user_id"], name: "index_steps_on_user_id"
  end

  create_table "steps_flows", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.bigint "flow_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flow_id"], name: "index_steps_flows_on_flow_id"
    t.index ["user_id"], name: "index_steps_flows_on_user_id"
  end

  create_table "suggestions", charset: "utf8mb3", force: :cascade do |t|
    t.text "description"
    t.bigint "user_id", null: false
    t.bigint "flow_id", null: false
    t.bigint "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flow_id"], name: "index_suggestions_on_flow_id"
    t.index ["part_id"], name: "index_suggestions_on_part_id"
    t.index ["user_id"], name: "index_suggestions_on_user_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "flows"
  add_foreign_key "comments", "parts"
  add_foreign_key "comments", "users"
  add_foreign_key "flows", "users"
  add_foreign_key "inspections", "flows"
  add_foreign_key "inspections", "parts"
  add_foreign_key "inspections", "users"
  add_foreign_key "parts", "flows"
  add_foreign_key "parts", "users"
  add_foreign_key "steps", "flows"
  add_foreign_key "steps", "parts"
  add_foreign_key "steps", "users"
  add_foreign_key "steps_flows", "flows"
  add_foreign_key "steps_flows", "users"
  add_foreign_key "suggestions", "flows"
  add_foreign_key "suggestions", "parts"
  add_foreign_key "suggestions", "users"
end
