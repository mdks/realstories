class DisableCommentsAndVoting < ActiveRecord::Migration
  def self.up
    add_column :stories, :disable_commenting, :boolean
    add_column :stories, :disable_voting, :boolean
  end

  def self.down
    remove_column :stories, :disable_commenting
    remove_column :stories, :disable_voting
  end
end
