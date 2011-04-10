class AddColumn01 < ActiveRecord::Migration
  def self.up
    add_column :items, :user_id, :integer
  end

  def self.down
  end
end
