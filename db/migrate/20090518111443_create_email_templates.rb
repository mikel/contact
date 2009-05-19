class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates do |t|
      t.string  :title
      t.text    :body
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :email_templates
  end
end
