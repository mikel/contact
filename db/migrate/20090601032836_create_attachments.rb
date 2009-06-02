class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.integer  :message_id
      t.string   :filename
      t.string   :directory
      t.binary   :data
      t.binary   :thumbnail
      t.string   :content_type
      t.integer  :height
      t.integer  :width
      t.integer  :size

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
