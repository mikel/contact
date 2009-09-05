class CreateSenders < ActiveRecord::Migration
  def self.up
    create_table :senders do |t|
      t.string  :name
      t.string  :from
      t.string  :reply_to
      t.integer :organization_id

      t.timestamps
    end
  end

  def self.down
    drop_table :senders
  end
end
