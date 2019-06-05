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

ActiveRecord::Schema.define(version: 20180102133353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string   "name"
    t.integer  "status",        default: 0
    t.integer  "controller_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["controller_id"], name: "index_actions_on_controller_id", using: :btree
  end

  create_table "controllers", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "esic_solicitacao", force: :cascade do |t|
    t.integer  "usuario_id"
    t.integer  "tipo_solicitacao_id"
    t.integer  "orgao_destinatario_id"
    t.text     "descricao"
    t.integer  "status"
    t.integer  "resposta_recebimento"
    t.string   "resposta_arquivo"
    t.integer  "resposta_visualizada"
    t.date     "resposta_data"
    t.date     "abertura_data"
    t.string   "protocolo"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "esic_usuariodetalhe", force: :cascade do |t|
    t.string   "cpf"
    t.string   "rg"
    t.string   "data_nascimento"
    t.integer  "tipo_pessoa"
    t.integer  "usuario_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "modulos", force: :cascade do |t|
    t.integer "users_id"
    t.string  "modulo_nome"
    t.string  "uri"
    t.integer "dominio"
    t.integer "status",      default: 0
    t.index ["users_id"], name: "index_modulos_on_users_id", using: :btree
  end

  create_table "patrimonios", force: :cascade do |t|
    t.string   "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "controllers_id"
    t.integer  "actions_id"
    t.integer  "profiles_id"
    t.integer  "status",         default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["actions_id"], name: "index_permissions_on_actions_id", using: :btree
    t.index ["controllers_id"], name: "index_permissions_on_controllers_id", using: :btree
    t.index ["profiles_id"], name: "index_permissions_on_profiles_id", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "status",      default: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "user_profiles", force: :cascade do |t|
    t.integer  "users_id"
    t.integer  "profiles_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["profiles_id"], name: "index_user_profiles_on_profiles_id", using: :btree
    t.index ["users_id"], name: "index_user_profiles_on_users_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "password"
    t.string   "nome"
    t.string   "email"
    t.string   "telefone"
    t.integer  "status",          default: 0
    t.integer  "codigo_ativacao"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "profile_id"
  end

  add_foreign_key "actions", "controllers"
  add_foreign_key "modulos", "users", column: "users_id"
  add_foreign_key "permissions", "actions", column: "actions_id"
  add_foreign_key "permissions", "controllers", column: "controllers_id"
  add_foreign_key "permissions", "profiles", column: "profiles_id"
  add_foreign_key "user_profiles", "profiles", column: "profiles_id"
  add_foreign_key "user_profiles", "users", column: "users_id"
end
