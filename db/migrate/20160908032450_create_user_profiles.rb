class CreateUserProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_profiles do |t|
      t.references :users, index: true, foreign_key: true
      t.references :profiles, index: true, foreign_key: true
      t.timestamps
    end
  end
end
