class CreateFeatures < ActiveRecord::Migration[5.2]
  def change
    create_table :features do |t|
      t.string :key

      t.timestamps
    end
    add_index :features, :key, unique: true
  end
end
