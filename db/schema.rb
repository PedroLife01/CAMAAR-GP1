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

ActiveRecord::Schema[7.2].define(version: 2025_07_10_054309) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "controle_de_envios", force: :cascade do |t|
    t.integer "aluno_id"
    t.integer "formulario_id"
    t.boolean "is_envio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aluno_id"], name: "index_controle_de_envios_on_aluno_id"
    t.index ["formulario_id"], name: "index_controle_de_envios_on_formulario_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.integer "id_template"
    t.integer "id_turma"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "titulo"
    t.text "descricao"
    t.datetime "data_abertura"
    t.datetime "data_fechamento"
    t.integer "id_docente"
    t.index ["id_template"], name: "index_formularios_on_id_template"
    t.index ["id_turma"], name: "index_formularios_on_id_turma"
  end

  create_table "resposta", force: :cascade do |t|
    t.integer "id_formulario"
    t.jsonb "respostas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "respostas", force: :cascade do |t|
    t.integer "id_formulario"
    t.jsonb "respostas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "aluno_id", null: false
    t.bigint "formulario_id", null: false
    t.integer "pergunta_index"
    t.text "conteudo"
    t.index ["aluno_id"], name: "index_respostas_on_aluno_id"
    t.index ["formulario_id", "aluno_id", "pergunta_index"], name: "index_respostas_unicas", unique: true
    t.index ["formulario_id"], name: "index_respostas_on_formulario_id"
    t.index ["id_formulario"], name: "index_respostas_on_id_formulario"
  end

  create_table "templates", force: :cascade do |t|
    t.integer "id_user"
    t.jsonb "formulario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.index ["id_user"], name: "index_templates_on_id_user"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.jsonb "class_data"
    t.integer "id_docente"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_docente"], name: "index_turmas_on_id_docente"
  end

  create_table "turmas_alunos", force: :cascade do |t|
    t.integer "turma_id"
    t.integer "aluno_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aluno_id"], name: "index_turmas_alunos_on_aluno_id"
    t.index ["turma_id"], name: "index_turmas_alunos_on_turma_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nome"
    t.string "curso"
    t.string "matricula"
    t.string "usuario"
    t.string "formacao"
    t.string "ocupacao"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "controle_de_envios", "formularios"
  add_foreign_key "controle_de_envios", "users", column: "aluno_id"
  add_foreign_key "formularios", "templates", column: "id_template"
  add_foreign_key "formularios", "turmas", column: "id_turma"
  add_foreign_key "respostas", "formularios"
  add_foreign_key "respostas", "formularios", column: "id_formulario"
  add_foreign_key "respostas", "users", column: "aluno_id"
  add_foreign_key "templates", "users", column: "id_user"
  add_foreign_key "turmas", "users", column: "id_docente"
  add_foreign_key "turmas_alunos", "turmas"
  add_foreign_key "turmas_alunos", "users", column: "aluno_id"
end
