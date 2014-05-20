desc "Add Missing Data"

task :add_urls_to_hikvision => :environment do
  cameras = Manufacturer.find_by_name("Hikvision").cameras.where("model like?", "DS-%")
  cameras.each do |camera|
    camera.jpeg_url = 'Streaming/Channels/1/picture'
    camera.h264_url = 'h264/ch1/main/av_stream'
    camera.mjpeg_url = 'None'
    camera.save
  end
end

desc "Fix duplicate resolutions"

task :fix_resolutions => :environment do
  Camera.all.each do |camera|
    if camera.resolution
      camera.resolution = camera.resolution.gsub(/\s+/, "").gsub(/×/, "x")
      camera.save
    end
  end
end

