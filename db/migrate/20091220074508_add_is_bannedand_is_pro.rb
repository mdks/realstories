class AddIsBannedandIsPro < ActiveRecord::Migration
  def self.up
    add_column :users, :is_banned, :boolean
    add_column :users, :is_pro, :boolean
  end

  def self.down
    remove_column :users, :is_banned
    remove_column :users, :is_pro
  end
end
