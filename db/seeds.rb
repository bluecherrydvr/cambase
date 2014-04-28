# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

seed_file = File.join(Rails.root, 'db', 'seeds', 'cameras.yml')
documents = YAML.load_stream(open(seed_file))
# NOTE: add temporary limit until the pagination is implemented

manufacturer_filter = [
  'AAAAAAA',
  'ADCi400-B022',
  'ADCi400-D022',
  'AlarmDotCom',
  'ASD',
  'asda',
  'asdad',
  'asix2',
  'at home',
  'bhjbnhj',
  'BLOCK_B_LOBBY',
  'CAM 01',
  'CAM 02',
  'CAM 03',
  'Cam01',
  'CAM01 - ACHTER',
  'CAM1',
  'Cam2',
  'CAM3',
  'Camara',
  'Camara 2',
  'Camara china',
  'camara',
  'Camera',
  'Camera 01',
  'Camera 02',
  'Camera 03',
  'Camera 1',
  'Camera_2',
  'Camera_3',
  'camera1',
  'camera2',
  'china',
  'chinese',
  'ChinaKamera',
  'E53--A-XX-13G-00029',
  'E73--A-XX-13G-00002',
  'E73--A-XX-13I-00238',
  'iPhone',
  'iPHONE_4_IPCAM',
  'iPhone-IpCamera',
  'iPod',
  'ipod touch',
  'b-qteck',
  'Galaxy S3',
  'Galaxy',
  'Galaxy Phone',
  'H 264 network DVR',
  'h series',
  'H.264',
  'h264',
  'MotornaKamera',
  'nexus',
  'Nexus 4',
  'Other',
  'Other1',
  'Samsung (Android',
  'Tablet',
  'Vantech',
  'Vantech1',
  'Vantech2'
]

def combine_manufacturers(manufacturer)
  manufacturer = case manufacturer
  when 'Android IP cam', 'Android Ip Webcam', 'Android Phone', 'Android Tablet', 'Android Webcam' then 'Android'
  when 'D Link', 'DLink', 'DLink', 'D-Link2', 'DLink3', 'DLink5', 'D-Link DCS 930L', 'DLINK EINFAHRT', 'D-Linl' then 'D-Link'
  when /\AAxis\s?/i then 'Axis'
  when /\ADCS/i then 'DCS'
  else manufacturer
  end
  return manufacturer
end

def combine_cameras(camera)
  camera = case camera
  when 'Other', 'Any', 'Unknown', 'other' then 'Default'
  else camera
  end
  return camera
end

documents.first(500).each do |doc|
  doc.first(1).each do |camera|
    if manufacturer_filter.include? camera['manufacturer']
      next
    end
    camera['manufacturer'] = combine_manufacturers(camera['manufacturer'])
    camera['model'] = combine_cameras(camera['model'])
    puts camera['manufacturer']
    manufacturer_id = Manufacturer.where(:name => camera['manufacturer']).first_or_create.id
    camera['manufacturer_id'] = manufacturer_id
    Camera.create(camera.except('manufacturer'))
  end
end
