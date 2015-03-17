require 'aws-sdk'
require 'open-uri'
require Rails.root.join('lib', 'import_data.rb')


desc "Export vendor images to cambase-public-assets from cambase"
task :export_vendor_images => :environment do
  AWS.config(
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'], 
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
    # disable this key if source bucket is in US
    #:s3_endpoint => 's3-eu-west-1.amazonaws.com'
  )
  s3 = AWS::S3.new
  cambase_bucket = s3.buckets['cambase']
  assets_bucket = s3.buckets['cambase-public-assets']
  assets_bucket.acl = :public_read

  path = "#{Rails.root}/tmp/vendors/"
  if Dir.exists?(path) == false
    Dir.mkdir(path)
  end
  Vendor.all.each do |v|
    vendorslug = vendor.vendor_slug
    if vendorslug == 'd-link' || vendorslug == 'tp-link' || vendorslug == 'y-cam'
      vendorslug.gsub!('-', '')
    end
    puts v.name
    filepath = "#{vendorslug}/logo.jpg"
    if v.image
      dirpath = path + "#{vendorslug}"
      if !Dir.exists?(dirpath)
        Dir.mkdir(dirpath)
      end
      begin
        ## no need if separately done
        #v.image.file.reprocess!
        v.image.file.copy_to_local_file(:thumbnail, path + filepath)
        puts " - Image downloaded (" + v.image.file.url + ")"
        assets_bucket.objects.create(filepath , Pathname.new(path + filepath))
        puts " - Image uploaded (" + filepath + ") #" + assets_bucket.objects.count.to_s
      rescue => e
        puts "ERR: " + e.message
      ensure
          File.delete(path + filepath) if File.exist?(path + filepath)
          Dir.delete(dirpath) if Dir.exist?(dirpath)
      end
    else
      puts " - Image not found"
    end
  end
  Dir.delete(path) if Dir.exist?(path)
end


desc "Export model images to cambase-public-assets from cambase of given vendor"
task :export_model_images, [:vendorname] => :environment do |t, args|
  vendor = Vendor.where(vendor_slug: args[:vendorname].downcase).first
  if vendor
    ## d-link = dlink, tp-link = tplink, y-cam = ycam
    vendorslug = vendor.vendor_slug
    if vendorslug == 'd-link' || vendorslug == 'tp-link' || vendorslug == 'y-cam'
      vendorslug.gsub!('-', '')
    end
    puts vendorslug

    AWS.config(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'], 
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      # disable this key if source bucket is in US
      #:s3_endpoint => 's3-eu-west-1.amazonaws.com'
    )
    s3 = AWS::S3.new
    assets_bucket = s3.buckets['cambase-public-assets']
    assets_bucket.acl = :public_read

    path = "#{Rails.root}/tmp/vendors/"
    if !Dir.exists?(path)
      Dir.mkdir(path)
    end
    models = Model.where(vendor_id: vendor.id)
    models.each do |m|
      model = m.model.downcase
      model.gsub!('/', '-slash-')
      model.gsub!('.', '-dot-')
      model.gsub!(' ', '-')
      model.gsub!('_', '-')
      model.gsub!('(', '-')
      model.gsub!('[', '-')
      model.gsub!(')', '')
      model.gsub!(']', '')
      model.squeeze!('-')
      puts model

      iconfilepath = "#{vendorslug}/#{model}/icon.jpg"
      thumbfilepath = "#{vendorslug}/#{model}/thumbnail.jpg"
      originalfilepath = "#{vendorslug}/#{model}/original.jpg"

      if m.images.count > 0
        ### no need if separately done
        first_image = m.images.sorted.first.file.reprocess!
        
        dirpath = path + "#{vendorslug}"
        if !Dir.exists?(dirpath)
          Dir.mkdir(dirpath)
        end
        dirpath = path + "#{vendorslug}/#{model}"
        if !Dir.exists?(dirpath)
          Dir.mkdir(dirpath)
        end
        begin
          first_image.file.copy_to_local_file(:icon, path + iconfilepath)
          first_image.file.copy_to_local_file(:thumbnail, path + thumbfilepath)
          first_image.file.copy_to_local_file(:original, path + originalfilepath)
          puts " - Image downloaded (" + first_image.file.url + ")"

          assets_bucket.objects.create(iconfilepath, Pathname.new(path + iconfilepath))
          assets_bucket.objects.create(thumbfilepath, Pathname.new(path + thumbfilepath))
          assets_bucket.objects.create(originalfilepath, Pathname.new(path + originalfilepath))
          puts " - Image uploaded #" + assets_bucket.objects.count.to_s
        rescue => e
          puts "ERR: " + e.message
        ensure
            File.delete(path + iconfilepath) if File.exist?(path + iconfilepath)
            File.delete(path + thumbfilepath) if File.exist?(path + thumbfilepath)
            File.delete(path + originalfilepath) if File.exist?(path + originalfilepath)
            Dir.delete(path + dirpath) if Dir.exist?(path + dirpath)
        end
      else
        puts " - Image not found"
      end
    end
    assets_bucket.acl = :public_read
    #Dir.delete(path) if Dir.exist?(path)
  else
    puts " - Vendor not found"
  end
end

desc "Refresh vendor images on cambase bucket"
task :refresh_vendor_images => :environment do
  Vendor.all.each do |v|
    puts v.name
    if v.image
      v.image.file.reprocess!
      puts " - Image refreshed " + v.image.file.url
    else
      puts " - Image not found"
    end
  end
end


desc "Fix models' model name"
task :fix_model_name, [:arg0] => :environment do |t, args|
  #@model = "Any_Model with-.-or (any sybmol) [should] [be] [replaced] (with / or / hyphen)"
  puts args[:arg0]
  @model_name = args[:arg0].downcase
  @model_name.gsub!('/', '-slash-')
  @model_name.gsub!('.', '-dot-')
  @model_name.gsub!(' ', '-')
  @model_name.gsub!('_', '-')
  @model_name.gsub!('(', '-')
  @model_name.gsub!('[', '-')
  @model_name.gsub!(')', '')
  @model_name.gsub!(']', '')
  @model_name.squeeze!('-')

  puts @model_name
end


desc "Refresh models' images on cambase bucket"
task :refresh_model_images => :environment do
  Model.all.each do |m|
    puts m.model
    if m.images.count > 1
      m.images.sorted.first.file.reprocess!
      puts " - Image refreshed " + m.images.sorted.first.file.url
    else
      puts " - Image not found"
    end
  end
end