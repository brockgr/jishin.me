class CreateCityCodes < ActiveRecord::Migration
  def self.up
    create_table :city_codes do |t|
      t.integer :city_code
      t.string :prefecture
      t.string :prefecture_kana
      t.string :prefecture_roman
      t.string :city
      t.string :city_kana
      t.string :city_roman

      t.timestamps
    end
    add_index :city_codes, :prefecture
    add_index :city_codes, :prefecture_kana
    add_index :city_codes, :prefecture_roman
    add_index :city_codes, :city
    add_index :city_codes, :city_kana
    add_index :city_codes, :city_roman
  end

  def self.down
    drop_table :city_codes
  end
end
