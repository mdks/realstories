class ChangeUserIdentifier < ActiveRecord::Migration
  def self.up
    # starting users table over
    drop_table :users
    
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :crypted_password, :default => nil, :null => true
      t.string :password_salt, :default => nil, :null => true
      t.string :persistence_token
      
      t.string :rpx_identifier
      t.index :rpx_identifier
      
      t.timestamps
    end
    
    #add_column :users, :rpx_identifier, :string
    #add_index :users, :rpx_identifier

    #change_column :users, :crypted_password, :string, , :default => nil, :null => true
    #change_column :users, :password_salt, :string, :default => nil, :null => true

  end

  def self.down
    remove_column :users, :rpx_identifier

    [:crypted_password, :password_salt].each do |field|
      User.all(:conditions => "#{field} is NULL").each { |user| user.update_attribute(field, "") if user.send(field).nil? }
      change_column :users, field, :string, :default => "", :null => false
    end
  end
end
