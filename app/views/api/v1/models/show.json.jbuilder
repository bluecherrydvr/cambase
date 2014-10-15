json.prettify!
json.models do
  json.partial! 'api/v1/models/model', model: @model, path: api_v1_models_url
end
