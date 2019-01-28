class CreateReleases < ActiveRecord::Migration[5.2]
  def change
    create_table :releases do |t|
      t.string :key

      t.timestamps
    end
    add_index :releases, :key, unique: true
  end
end
