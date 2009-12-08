class AddApprovedToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :is_approved, :boolean
  end

  def self.down
    remove_column :comments, :is_approved
  end
end
