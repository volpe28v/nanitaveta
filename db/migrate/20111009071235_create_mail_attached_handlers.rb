class CreateMailAttachedHandlers < ActiveRecord::Migration
  def self.up
    create_table :mail_attached_handlers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :mail_attached_handlers
  end
end
