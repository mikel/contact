class CreateRecipients < ActiveRecord::Migration
  def self.up
    create_table :recipients do |t|
      t.string  :given_name
      t.string  :family_name
      t.string  :email
      t.integer :undeliverable_count, :default => 0
      t.boolean :black_listed,        :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :recipients
  end
end
