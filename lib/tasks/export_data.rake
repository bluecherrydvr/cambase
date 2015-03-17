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
  Vendor.all.each do |v|
    puts v.name
    filepath = "#{Rails.root}/public/system/vendors/#{v.vendor_slug}/#{v.vendor_slug}.jpg"
    if v.image
      if Dir.exists?("#{Rails.root}/public/system/vendors/#{v.vendor_slug}") == false
        Dir.mkdir("#{Rails.root}/public/system/vendors/#{v.vendor_slug}")
      end
      begin
        v.image.file.reprocess!
        v.image.file.copy_to_local_file(:thumbnail, filepath)
        puts " - Image downloaded (" + v.image.file.url + ")"
        remotepath = "#{v.vendor_slug}/logo.jpg"
        assets_bucket.objects.create(remotepath, Pathname.new(filepath))
        puts " - Image uploaded (/" + remotepath + ") #" + assets_bucket.objects.count.to_s
        break
      rescue => e
        puts "ERR: " + e.message
      end
    else
      puts " - Image not found"
    end
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

desc "Refresh models' images on cambase bucket"
task :refresh_model_images => :environment do
  Model.all.each do |m|
    puts m.model + " - " + m.images.count.to_s
    if m.images.count > 1
      m.images.sorted.first.file.reprocess!
      puts " - Image refreshed " + m.images.sorted.first.file.url
    else
      puts " - Image not found"
    end
  end
end