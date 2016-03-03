# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160303000507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.date     "the_date"
    t.string   "boss"
    t.boolean  "active"
    t.integer  "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "activities", ["program_id"], name: "index_activities_on_program_id", using: :btree

  create_table "activities_students", id: false, force: :cascade do |t|
    t.integer "activity_id"
    t.integer "student_id"
  end

  add_index "activities_students", ["activity_id"], name: "index_activities_students_on_activity_id", using: :btree
  add_index "activities_students", ["student_id"], name: "index_activities_students_on_student_id", using: :btree

  create_table "attendances", force: :cascade do |t|
    t.integer  "identification"
    t.string   "period"
    t.integer  "went_days"
    t.integer  "skip_days"
    t.text     "reason"
    t.integer  "student_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "attendances", ["student_id"], name: "index_attendances_on_student_id", using: :btree

  create_table "establishments", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.string   "department"
    t.string   "state"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guardians", force: :cascade do |t|
    t.string   "id_type"
    t.integer  "identification"
    t.string   "name"
    t.string   "last_name"
    t.string   "second_name"
    t.string   "gender"
    t.date     "born"
    t.string   "address"
    t.string   "villa"
    t.string   "zone"
    t.string   "department"
    t.string   "municipality"
    t.string   "phone"
    t.string   "cel"
    t.string   "email"
    t.string   "relationship"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "student_id"
  end

  add_index "guardians", ["student_id"], name: "index_guardians_on_student_id", using: :btree

  create_table "health_cares", force: :cascade do |t|
    t.boolean  "affiliate"
    t.string   "regime"
    t.string   "eps"
    t.string   "ips"
    t.boolean  "register"
    t.string   "card"
    t.date     "poll_date"
    t.float    "score"
    t.boolean  "inhabilites"
    t.text     "inh_description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "student_id"
  end

  add_index "health_cares", ["student_id"], name: "index_health_cares_on_student_id", using: :btree

  create_table "homes", force: :cascade do |t|
    t.string   "name"
    t.text     "paragraph"
    t.string   "email"
    t.string   "pictures"
    t.text     "texto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "pic"
  end

  create_table "nutritions", force: :cascade do |t|
    t.float    "weight"
    t.float    "height"
    t.string   "period"
    t.string   "year"
    t.integer  "identification", limit: 8
    t.integer  "student_id"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "nutritions", ["student_id"], name: "index_nutritions_on_student_id", using: :btree
  add_index "nutritions", ["user_id"], name: "index_nutritions_on_user_id", using: :btree

  create_table "programs", force: :cascade do |t|
    t.string   "name"
    t.string   "line"
    t.string   "city"
    t.text     "description"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "schools", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.string   "address"
    t.string   "neighborhood"
    t.string   "zone"
    t.string   "contact_name"
    t.string   "contact_position"
    t.string   "phone"
    t.string   "email"
    t.boolean  "headquarter"
    t.boolean  "foundation_present"
    t.integer  "establishment_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "schools", ["establishment_id"], name: "index_schools_on_establishment_id", using: :btree

  create_table "scores", force: :cascade do |t|
    t.integer  "identification"
    t.string   "period"
    t.string   "area"
    t.string   "score"
    t.integer  "student_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "year"
    t.integer  "user_id"
  end

  add_index "scores", ["student_id"], name: "index_scores_on_student_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.string   "id_type"
    t.string   "gender"
    t.string   "address"
    t.string   "last_course"
    t.integer  "outschool_years"
    t.integer  "identification"
    t.date     "born"
    t.string   "etnic"
    t.string   "villa"
    t.string   "born_state"
    t.string   "displaced"
    t.string   "residency_state"
    t.string   "zone"
    t.integer  "guardian_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "school_id"
  end

  add_index "students", ["guardian_id"], name: "index_students_on_guardian_id", using: :btree
  add_index "students", ["school_id"], name: "index_students_on_school_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "activities", "programs"
  add_foreign_key "attendances", "students"
  add_foreign_key "guardians", "students"
  add_foreign_key "health_cares", "students"
  add_foreign_key "nutritions", "students"
  add_foreign_key "nutritions", "users"
  add_foreign_key "schools", "establishments"
  add_foreign_key "scores", "students"
  add_foreign_key "students", "guardians"
  add_foreign_key "students", "schools"
end
