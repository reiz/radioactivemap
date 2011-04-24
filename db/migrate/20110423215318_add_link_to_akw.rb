class AddLinkToAkw < ActiveRecord::Migration
  def self.up
    add_column :akws, :link, :string
  end

  def self.down
    remove_column :akws, :link
  end
end
