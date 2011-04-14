# -*- coding: utf-8 -*-

require "open-uri"

class Quake < ActiveRecord::Base
  belongs_to :region
  has_many :intensities, :dependent => :delete_all

  validates :tenki_url, :uniqueness => true

  def yahoo_url 
    "http://typhoon.yahoo.co.jp/weather/jp/earthquake/%04d-%02d-%02d-%02d-%02d.html" % [
       quake_time.year,
       quake_time.month,
       quake_time.day,
       quake_time.hour,
       quake_time.min,
    ]
  end

  def in_format(format=nil)
    [ quake_time.to_i, magnitude.to_i ]
  end

  def self.create_from_tenki(url) 

    doc = Nokogiri::HTML(open(url), nil, 'utf-8')

    quake_time  = doc.search('th[text()="発生時刻"]').first.next_element.text
    report_time = doc.search('h2[text()="地震情報"]').first.next_element.text
    time      = doc.search('h2[text()="地震情報"]').first.next_element.text
    epicenter = doc.search('th[text()="震源地"]').first.next_element.text
    latitude  = doc.search('th[text()="緯度"]').first.next_element.text
    longitude = doc.search('th[text()="経度"]').first.next_element.text
    magnitude = doc.search('th[text()="マグニチュード"]').first.next_element.text
    depth     = doc.search('th[text()="深さ"]').first.next_element.text

    (match, r_yr,r_mo,r_da,r_ho,r_mi) = *report_time.match(/(\d+)年(\d+)月(\d+)日 (\d+)時(\d+)分.*/)
    (match,      q_mo,q_da,q_ho,q_mi) = *quake_time.match(/(\d+)月(\d+)日 (\d+)時(\d+)分.*/)
    q_yr = (r_mo.to_i < q_mo.to_i) ? r_yr - 1 : r_yr # Handle quake in previous year to reading 12/31 11:59
    report_time = "%04d/%02d/%02d %02d:%02d:00 JST" % [r_yr,r_mo,r_da,r_ho,r_mi]
    quake_time = "%04d/%02d/%02d %02d:%02d:00 JST" % [q_yr,q_mo,q_da,q_ho,q_mi]

    longitude = longitude.sub(/^東経(.*)度/,'\1N').sub(/^西経(.*)度/,'\1S')
    latitude  = latitude.sub(/^北緯(.*)度/,'\1E').sub(/^南緯(.*)度/,'\1W')
    magnitude.sub!(/^M/,'')
    depth.sub!(/^約/,'')

    quake = self.create(
      :tenki_url => url,
      :report_time => report_time,
      :quake_time => quake_time,
      :latitude => latitude,
      :longitude => longitude,
      :magnitude => magnitude,
      :depth => depth,
      :region => Region.where(:name_ja => epicenter).first || Region.create(:name_ja => epicenter),
    )

    intensity = nil
    doc.search("table#seismicIntensity/tr").each do |row|
      cols = row.search("td")
      if cols.length > 0 
        if cols.length == 4 # with intensity
          intensity  = cols[0].text
          prefecture = cols[1].text
          regions    = cols[2].text
          cities     = cols[3].text
        elsif cols.length == 3 # colspanned
          prefecture = cols[0].text
          regions    = cols[1].text
          cities     = cols[2].text
        end
      end

      if intensity

        intensity = intensity.gsub(/\s/,'').sub(/^震度/,'').sub(/弱/, '-').sub(/強/,'+')
        prefecture.gsub!(/\s/,'')

        regions.split(/[\s+\u00A0]/).each do |region|
          if region != ""
            Intensity.create(
              :quake => quake,
              :value => intensity,
              :location => Region.where(:name_ja => region).first || Region.create(:name_ja => region),
            )
          end
        end

        cities.split(/[\s+\u00A0]/).each do |city|
          if city != ""
            Intensity.create(
              :quake => quake,
              :value => intensity,
              :location => City.where(:name_ja => city).first || City.create(:name_ja => city),
            )
          end
        end
      end

    end
  end

end
