class AddFbidToUser < ActiveRecord::Migration

  def self.up
    add_column :users, :fb_id, :string, :limit => 25
    add_index :users, :fb_id, :name => "index_users_on_fb_id"
  end

  def self.down
    remove_column :users, :fb_id
  end

end