class AddIsActivatedAndActivationCodeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_code, :string
    add_column :users, :is_activated, :boolean
  end

  def self.down
    remove_column :users, :activation_code
    remove_column :users, :is_activated
  end
end
