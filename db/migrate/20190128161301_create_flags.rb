class CreateFlags < ActiveRecord::Migration[5.2]
  def change
    create_table :flags do |t|
      t.belongs_to :feature
      t.belongs_to :release
      t.boolean :enabled, default: false

      t.timestamps
    end
    add_index :flags, [:feature_id, :release_id], unique: true
  end
end
