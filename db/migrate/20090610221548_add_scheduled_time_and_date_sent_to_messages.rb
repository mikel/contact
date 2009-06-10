class AddScheduledTimeAndDateSentToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :date_scheduled, :datetime
    add_column :messages, :date_sent, :datetime
  end

  def self.down
    remove_column :messages, :date_sent
    remove_column :messages, :date_scheduled
  end
end
