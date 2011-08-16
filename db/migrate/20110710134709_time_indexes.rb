class TimeIndexes < ActiveRecord::Migration
  def self.up
   add_index :quakes, :quake_time
   add_index :quakes, :magnitude
  end

  def self.down
   remove_index :quakes, :quake_time
   remove_index :quakes, :magnitude
  end
end
