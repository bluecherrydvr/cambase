json.prettify!
json.recorders do
  json.partial! 'api/v1/recorders/model', recorder: @recorder, path: api_v1_recorders_url
end
