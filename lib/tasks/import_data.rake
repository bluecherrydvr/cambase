require Rails.root.join('lib', 'import_data.rb')

desc "Import csv"

task :import_csv => :environment do
  Dir.glob('db/seeds/*.csv') do |file|
    SmarterCSV.process(file).each do |model|
      original_model = model.clone
      model.delete :megapixel
      model.delete :framerate
      model.delete :data_sheet
      model.delete :availability
      model.delete :user
      model.delete :mpeg4_url
      model.delete :audio_url
      model.delete :"detailed_shape_/_type_as_in_vendor_catalog"
      model.delete_if { |k, v| v.to_s.empty? }
      model[:official_url] = model.delete :page_reference
      model[:manual_url] = model.delete :user_manual
      model[:sd_card] = model.delete :sd_card_storage
      if model[:audio]
        model[:audio_in] = model.delete :audio
        model[:audio_out] = model[:audio_in]
      end
      if model[:default_user]
        model[:default_username] = model.delete :default_user
      end
      model[:vendor_id] = Vendor.where(:name => model[:manufacturer]).first_or_create.id
      model.delete :manufacturer
      if model[:resolution]
        if model[:resolution] == '?'
          model[:resolution] = ''
        else
          model[:resolution] = model[:resolution].gsub(/\s+/, "").gsub(/×/, "x").downcase
        end
      end

      model.update(model){|key,value| clean_csv_values(value)}
      c = Model.where(:model => model[:model]).first_or_initialize
      c.update_attributes(model)
      c.attributes.each do |k, v|
        if v == 'f'
          if model[k.to_sym]
            c[k.to_sym] = model[k.to_sym]
          else
            c[k.to_sym] = 'Unknown'
          end
        end
        c.save
      end

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
      vendor = Vendor.where(:vendor_slug => folder.to_url).first_or_create.id
      model = Model.where(model_slug: model_slug, vendor_id: vendor).first
      if model
        puts model
        File.open("db/seeds/images/#{folder}/#{item}") do |f|
          image = Image.create(:file => f)
          model.images.append(image)
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
    vendor = Vendor.where(vendor_slug: vendor['id']).first
    if vendor
      puts 'known_macs:'
      puts vendor['known_macs'].to_s
      vendor.mac = vendor['known_macs']
      vendor.save
    else
      puts 'no mac addresses for the vendor'
    end
    puts
  end
end
