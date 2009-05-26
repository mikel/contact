class AddStateToRecipients < ActiveRecord::Migration
  def self.up
    add_column :recipients, :state, :string, :limit => 10
  end

  def self.down
    remove_column :recipients, :state
  end
end
