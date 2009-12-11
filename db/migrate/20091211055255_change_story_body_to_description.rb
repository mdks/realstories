class ChangeStoryBodyToDescription < ActiveRecord::Migration
  def self.up
    rename_column :stories, :body, :description
    change_column :stories, :description, :string
  end

  def self.down
    change_column :stories, :description, :text
    rename_column :stories, :decription, :body
  end
end
