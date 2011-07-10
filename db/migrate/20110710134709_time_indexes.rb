class TimeIndexes < ActiveRecord::Migration
  def self.up
   add_index :quakes, :quake_time
  end

  def self.down
   dropindex :quakes, :quake_time
  end
end
