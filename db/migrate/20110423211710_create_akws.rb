class CreateAkws < ActiveRecord::Migration
  def self.up
    create_table :akws do |t|
      t.string :name
      t.string :akwtype
      t.string :status
      t.string :lat
      t.string :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :akws
  end
end
