class CreateActions < ActiveRecord::Migration[5.0]
  def change
    create_table :actions do |t|
      t.string :name
      t.integer :status, :default => 0
      t.references :controllers, index: true, foreign_key: true
      t.timestamps
    end
  end
end
