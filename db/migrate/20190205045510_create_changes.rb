class CreateChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :changes do |t|
      t.references :target, polymorphic: true
      t.string :target_action
      t.string :target_key
      t.json :diff
      t.belongs_to :user

      t.timestamps
    end
  end
end
