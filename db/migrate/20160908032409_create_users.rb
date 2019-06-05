class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login
      t.string :password
      t.string :nome
      t.string :email
      t.string :telefone
      t.integer :status, :default => 0
      t.integer :codigo_ativacao
      t.timestamps
    end
  end
end

# add_column :w_servicos, :tipo_equipe_id, :string, :limit => 50
# add_column :w_servicos, :tipo_equipe_id, :integer
# add_column :w_servicos, :direto, :boolean, default: false
# add_column :w_servicos, :tipo_equipe_id, :text
# add_column :w_servicos, :tipo_equipe_id, :decimal, :precision => 38, :scale => 16