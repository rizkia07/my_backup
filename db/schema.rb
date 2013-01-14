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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121214235436) do

  create_table "bookmarks", :force => true do |t|
    t.integer  "branch_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "branch_betters", :force => true do |t|
    t.integer  "branch_id"
    t.integer  "better_branch_id"
    t.integer  "val",              :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "branches", :force => true do |t|
    t.integer  "title_id"
    t.integer  "parent_id"
    t.integer  "leaf_num",   :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "fav_num",    :default => 0
    t.boolean  "is_fixed",   :default => false
    t.integer  "lang_id"
    t.boolean  "is_ng",      :default => false
    t.datetime "content_at"
    t.datetime "fav_at"
    t.integer  "better_id"
    t.integer  "parent_num"
    t.integer  "child_num",  :default => 0
    t.string   "title_c"
  end

  add_index "branches", ["parent_id", "title_id"], :name => "index_branches_on_parent_id_and_title_id"

  create_table "contents", :force => true do |t|
    t.integer  "leaf_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "favs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "leaf_id"
    t.boolean  "is_disabled"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "to_user_id"
  end

  create_table "feed_entries", :force => true do |t|
    t.integer  "feed_site_id"
    t.text     "uri"
    t.text     "title"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.datetime "published_at"
    t.text     "summary"
    t.text     "favicon"
  end

  create_table "feed_reads", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_entry_id"
    t.boolean  "is_read",       :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "view_count",    :default => 0
  end

  create_table "feed_sites", :force => true do |t|
    t.text     "title"
    t.text     "uri"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feed_subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_site_id"
    t.text     "title"
    t.text     "uri"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "inquiries", :force => true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.string   "issue_id"
    t.integer  "status_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issue_categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issues", :force => true do |t|
    t.integer  "tracker_id"
    t.string   "subject"
    t.text     "description"
    t.date     "due_date"
    t.integer  "category_id"
    t.integer  "status_id"
    t.integer  "assigned_to_id"
    t.integer  "priority_id"
    t.integer  "author_id"
    t.integer  "parent_id"
    t.integer  "root_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "leafs", :force => true do |t|
    t.integer  "branch_id"
    t.integer  "content_id"
    t.integer  "user_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "is_disabled",      :default => false
    t.integer  "fav_num",          :default => 0
    t.integer  "branch_parent_id"
  end

  add_index "leafs", ["branch_id", "user_id", "is_disabled"], :name => "index_leafs_on_branch_id_and_user_id_and_is_disabled"
  add_index "leafs", ["branch_parent_id", "user_id", "is_disabled"], :name => "index_leafs_on_branch_parent_id_and_user_id_and_is_disabled"

  create_table "log_access_words", :force => true do |t|
    t.integer  "user_id"
    t.integer  "title_id"
    t.integer  "branch_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "log_accesses", :force => true do |t|
    t.integer  "user_id"
    t.string   "ctrlr"
    t.string   "actn"
    t.string   "params"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "log_edit_words", :force => true do |t|
    t.integer  "user_id"
    t.integer  "branch_id"
    t.integer  "new_branch_id"
    t.integer  "parent_id"
    t.integer  "old_parent_id"
    t.boolean  "is_leaf"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "log_move_words", :force => true do |t|
    t.integer  "user_id"
    t.integer  "branch_id"
    t.integer  "new_branch_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "log_user_merges", :force => true do |t|
    t.integer  "old_user_id"
    t.integer  "new_user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.integer  "lang_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
    t.integer  "branch_id"
  end

  create_table "photos", :force => true do |t|
    t.string   "flickr_id"
    t.string   "url_q"
    t.string   "page"
    t.string   "username"
    t.string   "realname"
    t.string   "query"
    t.text     "info"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "queue_branches", :force => true do |t|
    t.boolean  "is_done"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "branch_id"
  end

  create_table "queue_leafs", :force => true do |t|
    t.boolean  "is_done"
    t.integer  "leaf_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "queue_titles", :force => true do |t|
    t.boolean  "is_done",    :default => false
    t.integer  "title_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "branch_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "themes", :force => true do |t|
    t.integer  "branch_id"
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "title_parents", :force => true do |t|
    t.integer  "title_id"
    t.integer  "parent_id"
    t.integer  "title_num",  :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_ng",      :default => false
  end

  create_table "title_tweets", :force => true do |t|
    t.integer  "title_id"
    t.integer  "tweet_id",   :limit => 8
    t.integer  "point",                   :default => 0
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "twitter_id"
  end

  create_table "title_users", :force => true do |t|
    t.integer  "title_id"
    t.integer  "user_id"
    t.integer  "point",       :default => 0
    t.datetime "checked_at"
    t.datetime "canceled_at"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.datetime "hot_at"
  end

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.boolean  "is_ng"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "url_id"
    t.integer  "branch_id"
    t.integer  "photo_id"
  end

  create_table "topics", :force => true do |t|
    t.integer  "branch_id"
    t.integer  "lang_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tutorial_users", :force => true do |t|
    t.integer  "tutorial_id"
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.datetime "goal_at"
    t.datetime "cancel_at"
    t.integer  "val",         :default => 0
  end

  create_table "tutorials", :force => true do |t|
    t.string   "title"
    t.string   "key"
    t.integer  "val"
    t.integer  "previous_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "branch_id_en"
    t.integer  "branch_id_ja"
  end

  create_table "tweets", :force => true do |t|
    t.text     "body"
    t.integer  "twitter_id"
    t.integer  "point",                              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_word_id"
    t.text     "body_escaped"
    t.boolean  "is_word",                            :default => false
    t.integer  "in_reply_to_status_id", :limit => 8
    t.boolean  "is_mecabed",                         :default => false
  end

  create_table "urls", :force => true do |t|
    t.text     "name"
    t.text     "url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "image"
    t.text     "body"
    t.text     "favicon"
    t.text     "body_summary"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "twitter_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "app_token"
    t.integer  "lang_id",            :default => 1
    t.integer  "org_id"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.datetime "premium_expired_at"
    t.text     "device_token"
  end

end
