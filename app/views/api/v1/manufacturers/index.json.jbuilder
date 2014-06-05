json.prettify!
json.partial! 'api/v1/metadata'
json.data do |data|
  json.partial! 'api/v1/paging', object: @manufacturers, path: api_v1_manufacturers_url
  json.manufacturers @manufacturers, partial: 'api/v1/manufacturers/manufacturer', as: :manufacturer
end
