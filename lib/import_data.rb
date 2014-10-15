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
  SmarterCSV.process("#{Rails.root}/tmp/update.csv").each do |model|
    model = Hash[model.map{ |k, v| [k, v.to_s] }]
    model[:vendor_id] = Vendor.where(:name => model[:"name_[vendor]"]).first_or_create.id
    model.delete :id
    model.delete :created_at
    model.delete :updated_at
    model.delete :"id_[vendor]"
    model.delete :"info_[vendor]"
    model.delete :"created_at_[vendor]"
    model.delete :"updated_at_[vendor]"
    model.delete :"vendor_slug_[vendor]"
    model.delete :"url_[vendor]"
    model.delete :"id_[images]"
    model.delete :"position_[images]"
    model.delete :"created_at_[images]"
    model.delete :"updated_at_[images]"
    model.delete :"file_[images]"
    model.delete :"name_[vendor]"

    model.update(model){|key,value| clean_exported_csv_values(value)}

    c = Model.where(:model => model[:model]).first_or_initialize
    c.update_attributes(model)
    puts "#{c.vendor.name} \n#{c.model} \n #{c.errors.messages.inspect} \n\n" unless c.errors.messages.blank?
  end
end

def import_documents_from_google_drive
  client = auth_google_drive_client

  drive = client.discovered_api('drive', 'v2')

  result = client.execute(
    api_method: drive.files.list,
    parameters: {
      maxResults: 1000,
      q: "mimeType = 'application/pdf' and ('04010857713529984123' in owners or '02928049532232239685' in owners or '13940272261418201147' in owners or '14262798246273853605' in owners)"
    }
    )

  result.data.items.each do |item|
    folder = print_parents(item.id).first.id
    folder_name = print_file(folder).title
    puts folder_name
    model = Model.find_by_model(folder_name)
    if model and item.downloadUrl
      file_content = client.execute(:uri => item.downloadUrl).body
      File.open("#{Rails.root}/tmp/#{item.title}", 'wb') do |file|
        file.write(file_content)
        document = Document.create(:file => file)
        model.documents.append(document)
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
      file_parent_folder_name = print_parents(folder).first.id
      vendor_name = print_file(file_parent_folder_name).title
      vendor = Vendor.where(vendor_slug: vendor_name.to_url).first
      puts "#{vendor_name} - #{folder_name}"
      if vendor
        model = Model.where(model_slug: folder_name.to_url, vendor_id: vendor.id).first
        if model and item.downloadUrl
          file_content = client.execute(:uri => item.downloadUrl).body
          File.open("#{Rails.root}/tmp/#{item.originalFilename}", 'wb') do |file|
            file.write(file_content)
            image = Image.create(:file => file)
            model.images.append(image)
            puts "#{model.vendor.name} \n#{model.model} \n #{model.errors.messages.inspect} \n\n" unless model.errors.messages.blank?
          end
          File.delete("#{Rails.root}/tmp/#{item.originalFilename}")
        end
      end
    end
    puts item.originalFilename
    puts
    sleep 10
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
