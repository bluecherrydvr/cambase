require Rails.root.join('lib', 'import_data.rb')

desc "Import csv"

task :import_csv => :environment do
  Dir.glob('db/seeds/*.csv') do |file|
    SmarterCSV.process(file).each do |camera|
      camera.delete :megapixel
      camera.delete :framerate
      camera.delete :data_sheet
      camera.delete :availability
      camera.delete :user
      camera.delete :mpeg4_url
      camera.delete :audio_url
      camera.delete :"detailed_shape_/_type_as_in_vendor_catalog"
      camera.delete_if { |k, v| v.to_s.empty? }
      camera[:official_url] = camera.delete :page_reference
      camera[:manual_url] = camera.delete :user_manual
      camera[:sd_card] = camera.delete :sd_card_storage
      if camera[:audio]
        camera[:audio_in] = camera.delete :audio
        camera[:audio_out] = camera[:audio_in]
      end
      if camera[:default_user]
        camera[:default_username] = camera.delete :default_user
      end
      camera[:manufacturer_id] = Manufacturer.where(:name => camera[:manufacturer]).first_or_create.id
      camera.delete :manufacturer
      if camera[:resolution]
        if camera[:resolution] == '?'
          camera[:resolution] = ''
        else
          camera[:resolution] = camera[:resolution].gsub(/\s+/, "").gsub(/×/, "x").downcase
        end
      end

      camera.update(camera){|key,value| clean_csv_values(value)}
      c = Camera.where(:model => camera[:model]).first_or_initialize
      c.update_attributes(camera)
      puts "#{c.model} \n #{c.errors.messages.inspect} \n\n" unless c.errors.messages.blank?
    end
  end
  puts "\nCSV Import complete! \n\n"
end

desc "Import images"

task :import_images => :environment do
  Dir.foreach('db/seeds/images/') do |folder|
    next if folder == '.' or folder == '..'
    Dir.foreach("db/seeds/images/#{folder}") do |item|
      next if item == '.' or item == '..'
      last_underscore = item.rindex('_')
      model_slug = item[0...last_underscore].to_url
      puts folder
      puts model_slug
      manufacturer = Manufacturer.where(:manufacturer_slug => folder.to_url).first_or_create.id
      camera = Camera.where(camera_slug: model_slug, manufacturer_id: manufacturer).first
      if camera
        puts camera
        File.open("db/seeds/images/#{folder}/#{item}") do |f|
          image = Image.create(:file => f)
          camera.images.append(image)
        end
      end
      puts
    end
  end
  puts "\nImage Import complete! \n\n"
end

desc "Import documents from google drive"

task :import_documents_from_google_drive => :environment do
  import_documents_from_google_drive
end

desc "Import images from google drive"

task :import_images_from_google_drive => :environment do
  import_images_from_google_drive
end

desc "Downloads csv from google drive"

task :download_csv_from_google_drive => :environment do
  download_csv_from_google_drive
end

desc "Import csv from google drive"

task :import_csv_from_google_drive => :environment do
  import_csv_from_google_drive
end

desc "Import MAC addresses from Evercam"

task :import_mac_addresses => :environment do
  connection = Faraday.new(url: "https://api.evercam.io:443") do |faraday|
    faraday.request :url_encoded
    faraday.adapter Faraday.default_adapter
  end

  response = connection.get "/v1/vendors.json?api_id=3d0e289b&api_key=#{ENV['EVERCAM_KEY']}"

  vendors = JSON.parse(response.body)['vendors']

  vendors.each do |vendor|
    manufacturer = Manufacturer.where(manufacturer_slug: vendor['id']).first
    if manufacturer
      puts 'known_macs:'
      puts vendor['known_macs'].to_s
      manufacturer.mac = vendor['known_macs']
      manufacturer.save
    else
      puts 'no mac addresses for the vendor'
    end
    puts
  end
end
