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

ActiveRecord::Schema.define(version: 20140818175607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "job_specs", force: true do |t|
    t.string   "name"
    t.boolean  "enabled",           default: false
    t.integer  "job_template_id"
    t.string   "job_template_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_specs", ["name"], name: "index_job_specs_on_name", unique: true, using: :btree

  create_table "tpl_birst_soap_generic_commands", force: true do |t|
    t.string   "command"
    t.string   "argument_json"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
