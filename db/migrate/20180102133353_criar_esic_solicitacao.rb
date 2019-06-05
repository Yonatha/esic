class CriarEsicSolicitacao < ActiveRecord::Migration[5.0]
  def change
    create_table :esic_solicitacao do |t|
      t.integer :usuario_id
      t.integer :tipo_solicitacao_id
      t.integer :orgao_destinatario_id
      t.text :descricao
      t.integer :status
      t.integer :resposta_recebimento
      t.string :resposta_arquivo
      t.integer :resposta_visualizada
      t.date :resposta_data
      t.date :abertura_data
      t.string :protocolo
      t.timestamps
    end
  end
end
