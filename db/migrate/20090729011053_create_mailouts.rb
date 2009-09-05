class CreateMailouts < ActiveRecord::Migration
  def self.up
    create_table :mailouts do |t|
      t.string   :title
      t.integer  :message_id
      t.integer  :user_id
      t.integer  :sender_id

      t.string   :aasm_state

      t.datetime :date_scheduled
      t.datetime :date_sent
      t.timestamps
    end
    
  end

  def self.down
    drop_table :mailouts
  end
end
