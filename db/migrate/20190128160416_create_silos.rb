class CreateSilos < ActiveRecord::Migration[5.2]
  def change
    create_table :silos do |t|
      t.string :key
      t.belongs_to :release

      t.timestamps
    end
    add_index :silos, :key, unique: true
  end
end
