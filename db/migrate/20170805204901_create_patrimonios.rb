class CreatePatrimonios < ActiveRecord::Migration[5.0]
  def change
    create_table :patrimonios do |t|
      t.string :nome

      t.timestamps
    end
  end
end
