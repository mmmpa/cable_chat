class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :key, null: false, index: {unique: true}
      t.string :uuid, null: false, index: {unique: true}
      t.integer :subscription, null: false, default: 0

      t.timestamps null: false
    end
  end
end
