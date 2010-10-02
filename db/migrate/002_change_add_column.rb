class ChangeAddColumn < ActiveRecord::Migration
  def self.up
    add_column :items, :cycle_mode, :string
#    change_column :items, :cycle, :integer
  end

  def self.down
  end
end
