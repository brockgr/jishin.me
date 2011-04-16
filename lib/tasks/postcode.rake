# -*- coding: utf-8 -*-

require "csv"
require "iconv"

desc "Parse KEN_ALL(_ROME).CSV data"
task :postcodes, :needs => :environment do |t, args|

if false
  CityCode.delete_all

  count = 0
  seen_ja = {}

  puts "Reading japanese"
  CSV.foreach("#{Rails.root}/db/KEN_ALL.CSV") do |row|
    #01637,"082  ","0820811","ﾎｯｶｲﾄﾞｳ","ｶｻｲｸﾞﾝﾒﾑﾛﾁｮｳ","ﾋｶﾞｼﾒﾑﾛ1ｼﾞｮｳﾐﾅﾐ","北海道","河西郡芽室町","東めむろ一条南",0,0,1,0,0,0
    puts "Row #{count}" if (count += 1) % 5000 == 0
    next if seen_ja[row[0]]
    row = row.map { |c| Iconv.iconv('UTf-8','SHIFT-JIS',c)[0] }
    (city_code, pc1, pc2, prefecture_kana, city_kana, area_kana, prefecture, city, area) = *row
    CityCode.create(
      :city_code => city_code,
      :prefecture => prefecture,
      :prefecture_kana => prefecture_kana,
      :city => city,
      :city_kana => city_kana,
    )
    seen_ja[city_code]=true
  end

  count = 0
  seen_en = {}

  puts "Reading roman"
  CSV.foreach("#{Rails.root}/db/KEN_ALL_ROME.CSV") do |row|
    #01637,"0820811","HIGASHIMEMURO1-JOMINAMI","MEMURO-CHO KASAI-GUN","HOKKAIDO",0,0,1,0,0,0
    puts "Row #{count}" if (count += 1) % 5000 == 0
    next if seen_en[row[0]]
    (city_code, pc, area, city, prefecture) = *row
    if (cc = CityCode.find_by_city_code(city_code)) 
      cc.prefecture_roman = prefecture.capitalize
      cc.city_roman = city.split(/\s+/).first.capitalize
      cc.save
    end
    seen_en[city_code]=true
  end

end
  City.all.each do |city|
    if (cc = CityCode.find_by_name_ja(city)) 
puts cc.city_roman
      city.name_en = cc.city_roman
      city.save
    end
  end

end
