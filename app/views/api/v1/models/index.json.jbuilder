json.prettify!
json.partial! 'api/v1/metadata'
json.data do |data|
  json.partial! 'api/v1/paging', object: @models, path: api_v1_models_url
  json.models @models do |model|
    json.id model['model_slug']
    json.vendor_id model.vendor['vendor_slug']
    json.url api_v1_model_url(model.model_slug, format: :json)
  end
end
