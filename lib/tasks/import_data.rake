desc "Import csv"

task :import_csv => :environment do
  cameras = SmarterCSV.process('db/seeds/cameras.csv')
  cameras.each do |camera|
    camera.delete :megapixel
    camera.delete :framerate
    camera.delete :page_reference
    camera.delete :poe
    camera.delete :data_sheet
    camera.delete :user
    camera.delete :wifi
    camera.delete_if { |k, v| v.empty? }
    camera[:manual_url] = camera.delete :user_manual
    camera[:sd_card] = camera.delete :sd_card_storage
    camera[:audio_in] = camera.delete :audio
    camera[:audio_out] = camera[:audio_in]
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
    Camera.where(:model => camera[:model]).first_or_initialize.update_attributes(camera)
  end
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
  when /4CIF/i
    '704×480'
  when /1080p|1920x1081/i
    '1920x1080'
  when /2058x1536|2050x1536|2048X1536/i
    '2048x1536'
  when /40x480/i
    '640x480'
  when /\?|wireless/i
    nil
  else
    value
  end
end
