class AddFbTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_token, :string
  end

  def self.down
    remove_column :users, :fb_token
  end
end