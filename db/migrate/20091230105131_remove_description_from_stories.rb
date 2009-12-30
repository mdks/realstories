class RemoveDescriptionFromStories < ActiveRecord::Migration
  def self.up
    remove_column :stories, :description
  end

  def self.down
    # no up lol!!
  end
end

