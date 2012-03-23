# -*- coding: utf-8 -*-

require "open-uri"

include Rails.application.routes.url_helpers;

@@count = 0
def pause 
  @@count += 1
  if ((@@count % 10) == 0)
    puts "sleep"
    sleep 5 
  end
end

def scrape(url) 

  pause
  puts "Parsing [#{url}]..."
  base = url.match(/^\w+:\/\/[^\/]+/).to_s

  new_count = 0
  doc = Nokogiri::HTML(open(url), nil, 'utf-8')
  doc.search("table#seismicInfoEntries/tr").each do |row|
    row.css('td a').each do |link|
      detail_url = base+link.get_attribute('href')
      if Quake.where(:tenki_url => detail_url).empty?
        pause
        new_count += 1
        puts "Get page [#{detail_url}]..."
        q=Quake.create_from_tenki(detail_url)
        q && q.intensities.each do |i|
          if i.location.is_a? City
            ActionController::Base.expire_page(city_path(i.location))
            ActionController::Base.expire_page(plot_city_path(i.location))
          end
          if i.location.is_a? Region
            ActionController::Base.expire_page(region_path(i.location))
            ActionController::Base.expire_page(plot_region_path(i.location))
          end
        end
      end
    end
  end

  if next_url = doc.search('#wrap_seismicInfoTableEntries a[text()="次へ"]').first.get_attribute('href')
    url = base+next_url
    return [new_count,url]
  else
    return [new_count,nil]
  end
end

desc "Scrape new"
task :scrape_new => :environment do |t, args|


  ActionController::Base.expire_page(quakes_path)
  ActionController::Base.expire_page(plot_quakes_path)
  ActionController::Base.expire_page(cities_path)

  # Clear out recent once in case they were updated
  Quake.where("created_at < date(report_time, '+24 hours')").each do |q|
    puts "Recheck: #{q.tenki_url}"
    ActionController::Base.expire_page(quake_path(q))
    q.destroy 
  end

  url = "http://tenki.jp/earthquake/entries?p=1"
  new_count = 1
  while ((new_count > 0) && url) 
    (new_count,url) = *scrape(url)
  end
end

desc "Scrape all urls"
task :scrape_all, [:url] => :environment do |t, args|
  url = args.url
  while (url) 
    (new_count,url) = *scrape(url)
  end
end
