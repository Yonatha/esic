class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :description
      t.integer :status, :default => 1
      t.timestamps
    end
  end
end
