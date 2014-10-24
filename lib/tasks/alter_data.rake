require Rails.root.join('lib', 'import_data.rb')

desc "Add Missing Data"

task :add_urls_to_hikvision => :environment do
  models = Vendor.find_by_name("Hikvision").models.where("model like?", "DS-%")
  models.each do |model|
    model.jpeg_url = 'Streaming/Channels/1/picture'
    model.h264_url = 'h264/ch1/main/av_stream'
    model.mjpeg_url = 'None'
    model.default_username = 'admin'
    model.default_password = '12345'
    model.save
  end
end

task :add_credentials_to_samsung => :environment do
  models = Vendor.find_by_name("Samsung").models
  models.each do |model|
    model.default_username = 'admin'
    model.default_password = '4321'
    model.save
  end
end

task :change_acm_models_url => :environment do
  acti = Vendor.where(name: "ACTi").first
  models = acti.models.where("model like?", "ACM%")
  models.each do |model|
    model.h264_url = '/'
    model.save
  end
end

desc "Fix duplicate resolutions"

task :fix_resolutions => :environment do
  Model.all.each do |model|
    if model.resolution
      model.resolution = model.resolution.gsub(/\s+/, "").gsub(/×/, "x").downcase
      model.save
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
      model = Model.find_by_model(folder_name)
      if model and item.downloadUrl
        model.images.each do |image|
          image.destroy
        end
        model.save
      end
    end
    puts item.originalFilename
    puts
    sleep 10
  end
  puts "\nDuplicate images deleted! \n\n"
end
