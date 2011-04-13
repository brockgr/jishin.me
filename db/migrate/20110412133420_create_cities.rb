class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name_en
      t.string :name_ja

      t.timestamps
    end
  end

  def self.down
    drop_table :cities
  end
end
