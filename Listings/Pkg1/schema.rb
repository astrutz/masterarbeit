# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_221_003_130_519) do # rubocop:disable Metrics/BlockLength
create_table 'credentials', force: :cascade do |t|
  t.string 'server'
  t.integer 'port'
  t.string 'ssl'
  t.string 'auth_type'
  t.string 'username'
  t.string 'password'
  t.integer 'recipient_id', null: false
  t.datetime 'created_at', null: false
  t.datetime 'updated_at', null: false
  t.index ['recipient_id'], name: 'index_credentials_on_recipient_id'
end

  create_table 'inboxes', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'messages', force: :cascade do |t|
    t.integer 'inbox_id'
    t.string 'sender_address'
    t.string 'recipient_address'
    t.string 'subject'
    t.datetime 'send_at', precision: nil
    t.text 'content'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'value_header'
    t.index ['inbox_id'], name: 'index_messages_on_inbox_id'
  end

  create_table 'recipients', force: :cascade do |t|
    t.string 'name'
    t.string 'email_address'
    t.string 'username'
    t.string 'password_digest'
    t.integer 'editing_performance_per_day'
    t.integer 'inbox_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['inbox_id'], name: 'index_recipients_on_inbox_id'
  end

  create_table 'rules', force: :cascade do |t|
    t.integer 'inbox_id'
    t.string 'field_to_search'
    t.string 'field_matcher'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['inbox_id'], name: 'index_rules_on_inbox_id'
  end

  create_table 'values', force: :cascade do |t|
    t.string 'sender_address'
    t.string 'recipient_address'
    t.datetime 'send_at', precision: nil
    t.integer 'amount'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'uuid'
  end

  add_foreign_key 'credentials', 'recipients'
  add_foreign_key 'recipients', 'inboxes'
end