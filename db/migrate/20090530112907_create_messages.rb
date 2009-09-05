class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string  :title
      t.string  :source
      t.boolean :multipart
      t.integer :user_id
      t.integer :email_template_id
      t.text    :html_part
      t.text    :plain_part

      t.string  :type
      t.string  :aasm_state

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
