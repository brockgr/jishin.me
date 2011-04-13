class CreateIntensities < ActiveRecord::Migration
  def self.up
    create_table :intensities do |t|
      t.integer :quake_id
      t.string :value
      t.string :location_type
      t.integer :location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :intensities
  end
end
