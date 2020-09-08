# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_13_070634) do

  create_table "assigned_members", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "character_id", null: false
    t.string "description"
    t.text "detail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id", "character_id"], name: "index_assigned_members_on_group_id_and_character_id", unique: true
  end

  create_table "attribute_configs", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "attribute_item_id", null: false
    t.boolean "is_visible", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "option_order"
    t.index ["is_visible"], name: "index_attribute_configs_on_is_visible"
    t.index ["project_id", "attribute_item_id"], name: "index_attribute_configs_on_project_id_and_attribute_item_id", unique: true
  end

  create_table "attribute_items", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "required", default: false, null: false
    t.integer "post_type", default: 0
    t.integer "kind", default: 0
    t.boolean "default_item", default: false
    t.integer "custom_folder_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["custom_folder_id"], name: "index_attribute_items_on_custom_folder_id"
    t.index ["default_item"], name: "index_attribute_items_on_default_item"
    t.index ["kind"], name: "index_attribute_items_on_kind"
    t.index ["post_type"], name: "index_attribute_items_on_post_type"
  end

  create_table "attribute_options", force: :cascade do |t|
    t.string "name", null: false
    t.integer "value", null: false
    t.integer "attribute_item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attribute_item_id", "value"], name: "index_attribute_options_on_attribute_item_id_and_value", unique: true
  end

  create_table "attribute_values", force: :cascade do |t|
    t.integer "attribute_item_id", null: false
    t.integer "post_id", null: false
    t.boolean "is_visible", default: false
    t.string "string"
    t.integer "integer"
    t.datetime "date"
    t.text "text"
    t.text "markdown"
    t.boolean "boolean"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "selected"
    t.index ["attribute_item_id", "post_id"], name: "index_attribute_values_on_attribute_item_id_and_post_id", unique: true
    t.index ["is_visible"], name: "index_attribute_values_on_is_visible"
  end

  create_table "categories", force: :cascade do |t|
    t.string "term_id", null: false
    t.string "name", null: false
    t.string "synopsis", default: ""
    t.text "body", default: ""
    t.integer "kind", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id", "term_id"], name: "index_categories_on_project_id_and_term_id", unique: true
    t.index ["term_id"], name: "index_categories_on_term_id"
  end

  create_table "character_relations", force: :cascade do |t|
    t.integer "from_id", null: false
    t.integer "to_id", null: false
    t.string "description"
    t.text "detail"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_id", "to_id"], name: "index_character_relations_on_from_id_and_to_id", unique: true
  end

  create_table "characters", force: :cascade do |t|
    t.integer "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_characters_on_post_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.integer "comment_id"
    t.text "body", null: false
    t.integer "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comment_id"], name: "index_comments_on_comment_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["status"], name: "index_comments_on_status"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "custom_folders", force: :cascade do |t|
    t.string "term_id", null: false
    t.string "name", null: false
    t.boolean "is_visible", default: false
    t.integer "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["term_id", "project_id"], name: "index_custom_folders_on_term_id_and_project_id", unique: true
  end

  create_table "custom_posts", force: :cascade do |t|
    t.integer "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "group_relations", force: :cascade do |t|
    t.integer "from_id", null: false
    t.integer "to_id", null: false
    t.string "description"
    t.text "detail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_id", "to_id"], name: "index_group_relations_on_from_id_and_to_id", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "parent_id"
    t.boolean "is_department", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_id"], name: "index_groups_on_parent_id"
    t.index ["post_id"], name: "index_groups_on_post_id"
  end

  create_table "post_relations", force: :cascade do |t|
    t.integer "from_id", null: false
    t.integer "to_id", null: false
    t.string "description"
    t.text "detail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_id", "to_id"], name: "index_post_relations_on_from_id_and_to_id", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "name", null: false
    t.string "term_id", null: false
    t.string "kana", null: false
    t.string "synopsis", default: ""
    t.integer "status", null: false
    t.integer "project_id", null: false
    t.integer "category_id"
    t.integer "user_id", null: false
    t.integer "last_editor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "custom_folder_id"
    t.integer "disclosure_range"
    t.index ["category_id", "term_id"], name: "index_posts_on_category_id_and_term_id", unique: true
    t.index ["custom_folder_id"], name: "index_posts_on_custom_folder_id"
    t.index ["disclosure_range"], name: "index_posts_on_disclosure_range"
    t.index ["kana"], name: "index_posts_on_kana"
    t.index ["last_editor_id"], name: "index_posts_on_last_editor_id"
    t.index ["name"], name: "index_posts_on_name"
    t.index ["project_id", "term_id"], name: "index_posts_on_project_id_and_term_id", unique: true
    t.index ["status"], name: "index_posts_on_status"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "project_followers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "approval", null: false
    t.integer "permission", default: 0
    t.index ["approval"], name: "index_project_followers_on_approval"
    t.index ["user_id", "project_id"], name: "index_project_followers_on_user_id_and_project_id", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "term_id", null: false
    t.string "name", null: false
    t.string "kana", null: false
    t.text "description", default: "", null: false
    t.boolean "is_published", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "commentable_status", default: 0
    t.integer "comment_viewable", default: 0
    t.integer "comment_publish", default: 0
    t.index ["comment_publish"], name: "index_projects_on_comment_publish"
    t.index ["comment_viewable"], name: "index_projects_on_comment_viewable"
    t.index ["commentable_status"], name: "index_projects_on_commentable_status"
    t.index ["term_id"], name: "index_projects_on_term_id"
    t.index ["user_id", "term_id"], name: "index_projects_on_user_id_and_term_id", unique: true
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "words", force: :cascade do |t|
    t.integer "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_words_on_post_id"
  end

  add_foreign_key "assigned_members", "characters"
  add_foreign_key "assigned_members", "groups"
  add_foreign_key "attribute_configs", "attribute_items"
  add_foreign_key "attribute_configs", "projects"
  add_foreign_key "attribute_options", "attribute_items"
  add_foreign_key "categories", "projects"
  add_foreign_key "character_relations", "characters", column: "from_id"
  add_foreign_key "character_relations", "characters", column: "to_id"
  add_foreign_key "characters", "posts"
  add_foreign_key "comments", "comments"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "custom_folders", "projects"
  add_foreign_key "custom_posts", "posts"
  add_foreign_key "group_relations", "groups", column: "from_id"
  add_foreign_key "group_relations", "groups", column: "to_id"
  add_foreign_key "groups", "groups", column: "parent_id"
  add_foreign_key "groups", "posts"
  add_foreign_key "post_relations", "posts", column: "from_id"
  add_foreign_key "post_relations", "posts", column: "to_id"
  add_foreign_key "posts", "categories"
  add_foreign_key "posts", "custom_folders"
  add_foreign_key "posts", "projects"
  add_foreign_key "posts", "users"
  add_foreign_key "posts", "users", column: "last_editor_id"
  add_foreign_key "project_followers", "projects"
  add_foreign_key "project_followers", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "words", "posts"
end
