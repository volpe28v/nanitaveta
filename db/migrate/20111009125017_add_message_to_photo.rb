class AddMessageToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :message, :string
  end

  def self.down
    remove_column :photos, :message
  end
end
