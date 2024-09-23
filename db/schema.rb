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

ActiveRecord::Schema[7.2].define(version: 2024_09_19_165908) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deputies", force: :cascade do |t|
    t.string "name", null: false
    t.string "party", null: false
    t.string "state", null: false
    t.string "cpf", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_deputies_on_cpf", unique: true
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "deputy_id", null: false
    t.string "supplier"
    t.decimal "liquid_value", precision: 15, scale: 2
    t.date "issue_date"
    t.string "invoice_url"
    t.string "document_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deputy_id"], name: "index_expenses_on_deputy_id"
    t.index ["document_number"], name: "index_expenses_on_document_number", unique: true
  end

  add_foreign_key "expenses", "deputies"
end
