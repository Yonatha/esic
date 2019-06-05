class CreateEsicUserDetalhes < ActiveRecord::Migration[5.0]
  def change
    create_table :esic_usuariodetalhe do |t|
      t.string :cpf
      t.string :rg
      t.string :data_nascimento
      t.integer :tipo_pessoa
      t.integer :usuario_id
      t.timestamps
    end
  end
end
