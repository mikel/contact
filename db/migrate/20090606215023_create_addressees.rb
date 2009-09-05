class CreateAddressees < ActiveRecord::Migration
  def self.up
    create_table :addressees do |t|
      t.integer :mailout_id
      t.integer :group_id
      t.integer :recipient_id

      t.timestamps
    end
  end

  def self.down
    drop_table :addressees
  end
end
