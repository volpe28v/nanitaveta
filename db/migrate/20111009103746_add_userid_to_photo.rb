class AddUseridToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :user_id, :integer
    add_column :photos, :path, :string
  end

  def self.down
    remove_column :photos, :path
    remove_column :photos, :user_id
  end
end
