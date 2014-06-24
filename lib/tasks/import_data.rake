desc "Import csv"

task :import_csv => :environment do
  Dir.glob('db/seeds/*.csv') do |file|
    SmarterCSV.process(file).each do |camera|
      camera.delete :megapixel
      camera.delete :framerate
      camera.delete :data_sheet
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

desc "Import documents"

task :import_documents => :environment do

  require 'google/api_client'

  key = OpenSSL::PKey::RSA.new(ENV['GOOGLE_DRIVE_KEY'], 'notasecret')

  @client = Google::APIClient.new({:application_name => "cambase-io", :application_version => "1.0"})
  @client.authorization = Signet::OAuth2::Client.new(
    :person => ENV['GOOGLE_DRIVE_PERSON'],
    :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
    :audience => 'https://accounts.google.com/o/oauth2/token',
    :scope => 'https://www.googleapis.com/auth/drive.readonly',
    :issuer => ENV['GOOGLE_DRIVE_ISSUER'],
    :signing_key => key
    )
  @client.authorization.fetch_access_token!
  @drive = @client.discovered_api('drive', 'v2')

  result = @client.execute(
    api_method: @drive.files.list,
    parameters: {
      maxResults: 1000,
      q: "mimeType = 'application/pdf' and ('04010857713529984123' in owners or '02928049532232239685' in owners or '13940272261418201147' in owners)"
    }
    )

  result.data.items.each do |item|
    folder = print_parents(item.id).first.id
    folder_name = print_file(folder).title
    puts folder_name
    camera = Camera.find_by_model(folder_name)
    if camera and item.downloadUrl
      file_content = @client.execute(:uri => item.downloadUrl).body
      File.open("#{Rails.root}/tmp/#{item.title}", 'wb') do |file|
        file.write(file_content)
        document = Document.create(:file => file)
        camera.documents.append(document)
      end
      File.delete("#{Rails.root}/tmp/#{item.title}")
    end
  end
end


desc "Import csv from google drive"

task :import_csv_from_google_drive => :environment do

  require 'google/api_client'

  key = OpenSSL::PKey::RSA.new(ENV['GOOGLE_DRIVE_KEY'], 'notasecret')

  @client = Google::APIClient.new({:application_name => "cambase-io", :application_version => "1.0"})
  @client.authorization = Signet::OAuth2::Client.new(
    :person => ENV['GOOGLE_DRIVE_PERSON'],
    :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
    :audience => 'https://accounts.google.com/o/oauth2/token',
    :scope => 'https://www.googleapis.com/auth/drive.readonly',
    :issuer => ENV['GOOGLE_DRIVE_ISSUER'],
    :signing_key => key
    )
  @client.authorization.fetch_access_token!
  @drive = @client.discovered_api('drive', 'v2')

  spreadsheet_url = "https://docs.google.com/a/mhlabs.net/spreadsheets/d/1TVUA5rVoCvA-ZHo1dw_uqr-e3n1qOYy-j7Ia1xetWTo/export?exportFormat=csv&amp;gid=0"

  file_content = @client.execute(:uri => spreadsheet_url).body
  File.open("#{Rails.root}/tmp/update.csv", 'wb') do |file|
    file.write(file_content)
  end
end

desc "Import csv dump"

task :import_csv_dump => :environment do
  SmarterCSV.process("#{Rails.root}/tmp/update.csv").each do |camera|
    camera = Hash[camera.map{ |k, v| [k, v.to_s] }]
    camera[:manufacturer_id] = Manufacturer.where(:name => camera[:"name_[manufacturer]"]).first_or_create.id
    camera.delete :id
    camera.delete :created_at
    camera.delete :updated_at
    camera.delete :"id_[manufacturer]"
    camera.delete :"info_[manufacturer]"
    camera.delete :"created_at_[manufacturer]"
    camera.delete :"updated_at_[manufacturer]"
    camera.delete :"manufacturer_slug_[manufacturer]"
    camera.delete :"url_[manufacturer]"
    camera.delete :"id_[images]"
    camera.delete :"position_[images]"
    camera.delete :"created_at_[images]"
    camera.delete :"updated_at_[images]"
    camera.delete :"file_[images]"
    camera.delete :"name_[manufacturer]"

    camera.update(camera){|key,value| clean_exported_csv_values(value)}

    c = Camera.where(:model => camera[:model]).first_or_initialize
    c.update_attributes(camera)
    puts "#{c.manufacturer.name} \n#{c.model} \n #{c.errors.messages.inspect} \n\n" unless c.errors.messages.blank?
  end
end

def print_parents(file_id)
  result = @client.execute(
    :api_method => @drive.parents.list,
    :parameters => { 'fileId' => file_id }
    )
  if result.status == 200
    parents = result.data
    parents.items.each do |parent|
      parent
    end
  else
    puts "An error occurred: #{result.data['error']['message']}"
  end
end

def print_file(file_id)
  result = @client.execute(
    :api_method => @drive.files.get,
    :parameters => { 'fileId' => file_id }
    )
  if result.status == 200
    file = result.data
  else
    puts "An error occurred: #{result.data['error']['message']}"
  end
end

def search_for(query)
  result = @client.execute(
    api_method: @drive.files.list,
    parameters: {
      maxResults: 1000,
      q: "#{query}"
    }
    )
end

def clean_csv_values(value)
  case value
  when /^YES/i
    true
  when /^NO|N0/i
    false
  when /Bi-directional/i
    true
  when /FishEye|FixedDome|Vandal-Resistant Dome|PTZ Domes/i
    'dome'
  when /Dome|Box|Bullet/i
    value.downcase
  when '4CIF', '4cif'
    '704×480'
  when '1080p', '1920x1081'
    '1920x1080'
  when '2058x1536', '2050x1536', '2048X1536'
    '2048x1536'
  when '40x480'
    '640x480'
  when '?', 'Wireless'
    nil
  else
    value
  end
end

def clean_exported_csv_values(value)
  case value
  when '?', '-', 'nil'
    nil
  else
    value
  end
end
