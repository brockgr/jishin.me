class CreateQuakes < ActiveRecord::Migration
  def self.up
    create_table :quakes do |t|
      t.datetime :quake_time
      t.datetime :report_time
      t.integer :region_id
      t.string :latitude
      t.string :longitude
      t.string :magnitude
      t.string :depth
      t.string :tenki_url

      t.timestamps
    end
  end

  def self.down
    drop_table :quakes
  end
end
