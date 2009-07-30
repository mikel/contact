class CreateMailouts < ActiveRecord::Migration
  def self.up
    create_table :mailouts do |t|
      t.string   :title
      t.integer  :message_id
      t.string   :aasm_state
      t.integer  :user_id
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :date_scheduled
      t.datetime :date_sent

      t.timestamps
    end
    
    # Need to remove the date_scheduled and date_sent from message,
    # is part of a mailout
    remove_column :messages, :date_scheduled
    remove_column :messages, :date_sent
    
    rename_column :addressees, :message_id, :mailout_id
    
  end

  def self.down
    rename_column :addressees, :mailout_id, :message_id
    add_column :messages, :date_sent, :datetime
    add_column :messages, :date_scheduled, :datetime
    drop_table :mailouts
  end
end
