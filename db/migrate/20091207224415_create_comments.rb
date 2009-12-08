class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :body
      t.integer :user_id
      t.integer :story_id
      t.float :score

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
