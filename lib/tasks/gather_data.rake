desc "Scrape ispyconnect cameras"

require 'nokogiri'
require 'open-uri'
vendors = []

task :scrape_ispyconnect do
  url = "http://www.ispyconnect.com/sources.aspx"
  doc = Nokogiri::HTML(open(url))
  vendor_links = doc.css('.sourcelist tr a').map { |link| link['href'] }
  vendor_links.drop(780).each { |v| vendors.push(v) }
  vendors.each do |vendor|
    scrape_ispyconnect_vendor(vendor)
  end
  puts vendors.length
end

def scrape_ispyconnect_vendor(vendor_url)

  url = "http://www.ispyconnect.com/#{vendor_url}"
  doc = Nokogiri::HTML(open(url, :read_timeout => 10))
  seed_file = File.join(Rails.root, 'db', 'seeds', 'cameras.yml')
  cameras = []

  heading = doc.css('.about h1').text.gsub!(" IP camera URL", "")
  table_rows = doc.css('tr.even, tr.odd')
  table_rows.each do |row|

    camera = Hash.new
    camera['manufacturer'] = heading
    camera['model'] = row.css('td')[0].text

    case row.css('td')[1].text
    when "JPEG"
      camera['jpeg_url'] = row.css('td')[2].text
    when "MJPEG"
      camera['mjpeg_url'] = row.css('td')[2].text
    when "FFMPEG", "VLC"
      camera['h264_url'] = row.css('td')[2].text
    else
    end

    cameras.push(camera)
  end

  puts cameras.to_yaml

  File.open(seed_file, "a") do |f|
    f.write(cameras.to_yaml)
  end

  sleep 2
end
