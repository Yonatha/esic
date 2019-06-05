class CreatePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :permissions do |t|
      t.references :controllers, index: true, foreign_key: true
      t.references :actions, index: true, foreign_key: true
      t.references :profiles, index: true, foreign_key: true
      t.integer :status, :default => 0
      t.timestamps
    end
  end
end
