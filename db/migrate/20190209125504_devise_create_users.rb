class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :jti, null: false

      t.timestamps null: false
    end

    add_index :users, :jti, unique: true
    add_index :users, :username, unique: true
  end
end
