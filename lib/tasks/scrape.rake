# -*- coding: utf-8 -*-

require "open-uri"


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
        Quake.create_from_tenki(detail_url)
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
task :scrape_new, :needs => :environment do |t, args|
  url = "http://tenki.jp/earthquake/entries?p=2"
  new_count = 1
  while ((new_count > 0) && url) 
    (new_count,url) = *scrape(url)
  end
end

desc "Scrape a url"
task :scrape_all, :url, :needs => :environment do |t, args|
  url = args.url
  while (url) 
    (new_count,url) = *scrape(url)
  end
end
