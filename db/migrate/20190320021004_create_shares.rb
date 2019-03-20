class CreateShares < ActiveRecord::Migration[5.1]
  def change
    create_table :shares do |t|
      t.integer :shared_id
      t.integer :sharedpost_id

      t.timestamps
    end
    add_index :shares, :shared_id
    add_index :shares, :sharedpost_id
    add_index :shares, [:shared_id, :sharedpost_id], unique: true
  end
end
