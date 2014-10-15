json.prettify!
json.partial! 'api/v1/metadata'
json.data do |data|
  json.partial! 'api/v1/paging', object: @vendors, path: api_v1_vendors_url
  json.vendors @vendors, partial: 'api/v1/vendors/vendor', as: :vendor
end
