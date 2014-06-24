def auth_google_drive_client
  require 'google/api_client'

  key = OpenSSL::PKey::RSA.new(ENV['GOOGLE_DRIVE_KEY'], 'notasecret')

  client = Google::APIClient.new({:application_name => "cambase-io", :application_version => "1.0"})
  client.authorization = Signet::OAuth2::Client.new(
    :person => ENV['GOOGLE_DRIVE_PERSON'],
    :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
    :audience => 'https://accounts.google.com/o/oauth2/token',
    :scope => 'https://www.googleapis.com/auth/drive.readonly',
    :issuer => ENV['GOOGLE_DRIVE_ISSUER'],
    :signing_key => key
    )
  client.authorization.fetch_access_token!

  client
end

def download_csv_from_google_drive

  client = auth_google_drive_client

  spreadsheet_url = "https://docs.google.com/a/mhlabs.net/spreadsheets/d/1TVUA5rVoCvA-ZHo1dw_uqr-e3n1qOYy-j7Ia1xetWTo/export?exportFormat=csv&amp;gid=0"

  file_content = client.execute(:uri => spreadsheet_url).body
  File.open("#{Rails.root}/tmp/update.csv", 'wb') do |file|
    file.write(file_content)
  end
end

def import_csv_from_google_drive
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

def import_documents_from_google_drive
  client = auth_google_drive_client

  drive = client.discovered_api('drive', 'v2')

  result = client.execute(
    api_method: drive.files.list,
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
      file_content = client.execute(:uri => item.downloadUrl).body
      File.open("#{Rails.root}/tmp/#{item.title}", 'wb') do |file|
        file.write(file_content)
        document = Document.create(:file => file)
        camera.documents.append(document)
      end
      File.delete("#{Rails.root}/tmp/#{item.title}")
    end
  end
end

def import_images_from_google_drive
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
       file_content = client.execute(:uri => item.downloadUrl).body
       File.open("#{Rails.root}/tmp/#{item.originalFilename}", 'wb') do |file|
         file.write(file_content)
         image = Image.create(:file => file)
         camera.images.append(image)
         puts "#{camera.manufacturer.name} \n#{camera.model} \n #{camera.errors.messages.inspect} \n\n" unless camera.errors.messages.blank?
       end
       File.delete("#{Rails.root}/tmp/#{item.originalFilename}")
     end
   end
   puts item.originalFilename
   puts
   sleep 5
 end

end

def print_parents(file_id)
  client = auth_google_drive_client
  drive = client.discovered_api('drive', 'v2')
  result = client.execute(
    :api_method => drive.parents.list,
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
  client = auth_google_drive_client
  drive = client.discovered_api('drive', 'v2')
  result = client.execute(
    :api_method => drive.files.get,
    :parameters => { 'fileId' => file_id }
    )
  if result.status == 200
    file = result.data
  else
    puts "An error occurred: #{result.data['error']['message']}"
  end
end

def search_for(query)
  client = auth_google_drive_client
  drive = client.discovered_api('drive', 'v2')
  result = client.execute(
    api_method: drive.files.list,
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

def call_rake(task, options = {})
  puts 'rake initiated!'
  options[:rails_env] ||= Rails.env
  args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
  system "bundle exec rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
end
