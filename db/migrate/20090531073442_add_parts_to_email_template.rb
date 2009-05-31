class AddPartsToEmailTemplate < ActiveRecord::Migration
  def self.up
    add_column :email_templates, :html_part, :text
    add_column :email_templates, :plain_part, :text
    remove_column :email_templates, :body
  end

  def self.down
    add_column :email_templates, :body, :text
    remove_column :email_templates, :plain_part
    remove_column :email_templates, :html_part
  end
end
