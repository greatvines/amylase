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

ActiveRecord::Schema.define(version: 20141126001734) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "birst_extract_group_collection_associations", force: true do |t|
    t.integer  "birst_extract_group_id"
    t.integer  "birst_extract_group_collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "birst_extract_group_collection_associations", ["birst_extract_group_collection_id"], name: "idx_birst_extract_group_collection_associations_collection_id", using: :btree
  add_index "birst_extract_group_collection_associations", ["birst_extract_group_id", "birst_extract_group_collection_id"], name: "idx_birst_extract_group_collection_associations", unique: true, using: :btree

  create_table "birst_extract_group_collections", force: true do |t|
    t.text     "name",        null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "birst_extract_group_collections", ["name"], name: "index_birst_extract_group_collections_on_name", unique: true, using: :btree

  create_table "birst_extract_groups", force: true do |t|
    t.text     "name",        null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "birst_extract_groups", ["name"], name: "index_birst_extract_groups_on_name", unique: true, using: :btree

  create_table "birst_process_group_collection_associations", force: true do |t|
    t.integer  "birst_process_group_id"
    t.integer  "birst_process_group_collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "birst_process_group_collection_associations", ["birst_process_group_collection_id"], name: "idx_birst_process_group_collection_associations_collection_id", using: :btree
  add_index "birst_process_group_collection_associations", ["birst_process_group_id", "birst_process_group_collection_id"], name: "idx_birst_process_group_collection_associations", unique: true, using: :btree

  create_table "birst_process_group_collections", force: true do |t|
    t.text     "name",        null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "birst_process_group_collections", ["name"], name: "index_birst_process_group_collections_on_name", unique: true, using: :btree

  create_table "birst_process_groups", force: true do |t|
    t.text     "name",        null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "birst_process_groups", ["name"], name: "index_birst_process_groups_on_name", unique: true, using: :btree

  create_table "birst_spaces", force: true do |t|
    t.text     "name",                  null: false
    t.integer  "client_id"
    t.text     "space_type"
    t.string   "space_uuid", limit: 36, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "birst_spaces", ["client_id"], name: "index_birst_spaces_on_client_id", using: :btree
  add_index "birst_spaces", ["name"], name: "index_birst_spaces_on_name", unique: true, using: :btree

  create_table "clients", force: true do |t|
    t.text     "name",                null: false
    t.text     "redshift_schema"
    t.text     "salesforce_username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["name"], name: "index_clients_on_name", unique: true, using: :btree

  create_table "data_source_collection_associations", force: true do |t|
    t.integer  "data_source_id"
    t.integer  "data_source_collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_source_collection_associations", ["data_source_collection_id"], name: "idx_data_source_collections_association_data_source_collection", using: :btree
  add_index "data_source_collection_associations", ["data_source_id", "data_source_collection_id"], name: "idx_data_source_collections_associations", unique: true, using: :btree

  create_table "data_source_collections", force: true do |t|
    t.text     "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_source_collections", ["name"], name: "index_data_source_collections_on_name", unique: true, using: :btree

  create_table "data_sources", force: true do |t|
    t.text     "name",             null: false
    t.text     "birst_filename"
    t.text     "data_source_type", null: false
    t.text     "redshift_sql"
    t.text     "s3_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "custom_header"
  end

  add_index "data_sources", ["name"], name: "index_data_sources_on_name", unique: true, using: :btree

  create_table "job_schedule_groups", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_schedule_groups", ["name"], name: "index_job_schedule_groups_on_name", unique: true, using: :btree

  create_table "job_schedules", force: true do |t|
    t.integer  "job_schedule_group_id"
    t.string   "schedule_method",       limit: 20
    t.string   "schedule_time",         limit: 80
    t.string   "first_at",              limit: 80
    t.string   "last_at",               limit: 80
    t.integer  "number_of_times"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_schedules", ["job_schedule_group_id"], name: "index_job_schedules_on_job_schedule_group_id", using: :btree

  create_table "job_specs", force: true do |t|
    t.string   "name"
    t.boolean  "enabled",               default: true
    t.integer  "job_template_id"
    t.string   "job_template_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_schedule_group_id"
    t.integer  "client_id"
  end

  add_index "job_specs", ["client_id"], name: "index_job_specs_on_client_id", using: :btree
  add_index "job_specs", ["job_schedule_group_id"], name: "index_job_specs_on_job_schedule_group_id", using: :btree
  add_index "job_specs", ["job_template_id"], name: "index_job_specs_on_job_template_id", using: :btree
  add_index "job_specs", ["name"], name: "index_job_specs_on_name", unique: true, using: :btree

  create_table "launched_jobs", force: true do |t|
    t.integer  "job_spec_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "status"
    t.text     "status_message"
    t.text     "result_data"
    t.text     "log_file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_priority"
  end

  add_index "launched_jobs", ["job_spec_id"], name: "index_launched_jobs_on_job_spec_id", using: :btree

  create_table "tpl_birst_duplicate_spaces", force: true do |t|
    t.string   "from_space_id_str", limit: 36
    t.string   "to_space_name"
    t.boolean  "with_membership"
    t.boolean  "with_data"
    t.boolean  "with_datastore"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tpl_birst_soap_generic_commands", force: true do |t|
    t.string   "command",       limit: 80
    t.string   "argument_json", limit: 1024
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tpl_birst_staged_refreshes", force: true do |t|
    t.integer  "data_source_collection_id"
    t.integer  "birst_process_group_collection_id"
    t.integer  "production_space_id"
    t.integer  "staging_space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tpl_birst_staged_refreshes", ["birst_process_group_collection_id"], name: "idx_tpl_staged_refresh_process_group_collection", using: :btree
  add_index "tpl_birst_staged_refreshes", ["data_source_collection_id"], name: "index_tpl_birst_staged_refreshes_on_data_source_collection_id", using: :btree
  add_index "tpl_birst_staged_refreshes", ["production_space_id"], name: "index_tpl_birst_staged_refreshes_on_production_space_id", using: :btree
  add_index "tpl_birst_staged_refreshes", ["staging_space_id"], name: "index_tpl_birst_staged_refreshes_on_staging_space_id", using: :btree

  create_table "tpl_dev_tests", force: true do |t|
    t.text     "argument"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sleep_seconds", default: 0
  end

end
