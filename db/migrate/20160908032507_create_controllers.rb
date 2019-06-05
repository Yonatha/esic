class CreateControllers < ActiveRecord::Migration[5.0]
  def change
    create_table :controllers do |t|
      t.string :name
      t.string :description
      t.integer :status, :default => 0
      t.timestamps
    end
  end
end