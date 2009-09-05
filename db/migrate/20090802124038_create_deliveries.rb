class CreateDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries do |t|
      t.integer     :user_id
      t.integer     :recipient_id
      t.integer     :mailout_id
      
      t.integer     :sent_at
      
      t.timestamps
    end
    
  end

  def self.down
    drop_table :deliveries
  end
end
