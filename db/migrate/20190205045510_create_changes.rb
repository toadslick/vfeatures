class CreateChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :changes do |t|
      t.string :action
      t.string :target_key
      t.references :target, polymorphic: true
      t.json :diff

      t.timestamps
    end
  end
end
