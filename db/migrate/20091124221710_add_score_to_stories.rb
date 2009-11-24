class AddScoreToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :score, :float
  end

  def self.down
    remove_column :stories, :score
  end
end
