class CreateChapters < ActiveRecord::Migration
  def self.up
    create_table :chapters do |t|
      t.string :chapter_name
      t.integer :chapter_number
      t.integer :story_id

      t.timestamps
    end
  end

  def self.down
    drop_table :chapters
  end
end
