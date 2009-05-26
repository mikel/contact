class AddOrganizationToUsersAndRecipients < ActiveRecord::Migration
  def self.up
    add_column :users, :organization_id, :integer
    add_column :recipients, :organization_id, :integer
  end

  def self.down
    remove_column :recipients, :organization_id
    remove_column :users, :organization_id
  end
end
