require Rails.root.join('lib', 'import_data.rb')

desc "Add Missing Data"

task :add_urls_to_hikvision => :environment do
  cameras = Manufacturer.find_by_name("Hikvision").cameras.where("model like?", "DS-%")
  cameras.each do |camera|
    camera.jpeg_url = 'Streaming/Channels/1/picture'
    camera.h264_url = 'h264/ch1/main/av_stream'
    camera.mjpeg_url = 'None'
    camera.default_username = 'admin'
    camera.default_password = '12345'
    camera.save
  end
end

task :add_credentials_to_samsung => :environment do
  cameras = Manufacturer.find_by_name("Samsung").cameras
  cameras.each do |camera|
    camera.default_username = 'admin'
    camera.default_password = '4321'
    camera.save
  end
end

task :change_acm_cameras_url => :environment do
  acti = Manufacturer.where(name: "ACTi").first
  cameras = acti.cameras.where("model like?", "ACM%")
  cameras.each do |camera|
    camera.h264_url = '/'
    camera.save
  end
end

desc "Fix duplicate resolutions"

task :fix_resolutions => :environment do
  Camera.all.each do |camera|
    if camera.resolution
      camera.resolution = camera.resolution.gsub(/\s+/, "").gsub(/×/, "x").downcase
      camera.save
    end
  end
end

desc "Delete duplicate images"

task :delete_duplicate_images => :environment do
  client = auth_google_drive_client

  drive = client.discovered_api('drive', 'v2')

  result = client.execute(
    api_method: drive.files.list,
    parameters: {
      maxResults: 1000,
      q: "mimeType contains 'image' and ('04010857713529984123' in owners or '02928049532232239685' in owners or '13940272261418201147' in owners)"
    }
    )

  result.data.items.each do |item|
    folder = print_parents(item.id).first.id
    if folder
      folder_name = print_file(folder).title
      puts folder_name
      camera = Camera.find_by_model(folder_name)
      if camera and item.downloadUrl
        camera.images.each do |image|
          image.destroy
        end
        camera.save
      end
    end
    puts item.originalFilename
    puts
    sleep 10
  end
  puts "\nDuplicate images deleted! \n\n"
end
