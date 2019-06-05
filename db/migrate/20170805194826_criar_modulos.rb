class CriarModulos < ActiveRecord::Migration[5.0]
  def change
    create_table :modulos do |t|
      t.references :users, index: true, foreign_key: true
      t.string :modulo_nome
      t.string :uri
      t.integer :dominio
      t.integer :status, :default => 0
    end
  end
end
