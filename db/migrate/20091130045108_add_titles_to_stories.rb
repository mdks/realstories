class AddTitlesToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :title, :string
  end

  def self.down
    remove_column :stories, :title
  end
end
