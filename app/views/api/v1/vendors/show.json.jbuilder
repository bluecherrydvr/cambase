json.prettify!
json.partial! 'api/v1/metadata'
json.data do |data|
  json.partial! 'api/v1/paging', object: @models, path: api_v1_vendor_url
  json.partial! 'api/v1/vendors/vendor', vendor: @vendor
  json.models @vendor.models do |model|
    json.partial! 'api/v1/models/model', model: model
  end
end
