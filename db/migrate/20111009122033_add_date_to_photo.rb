class AddDateToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :date, :datetime
  end

  def self.down
    remove_column :photos, :date
  end
end
