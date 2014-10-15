json.prettify!
json.partial! 'api/v1/metadata'
json.data do |data|
  json.partial! 'api/v1/paging', object: @recorders, path: api_v1_recorders_url
  json.recorders @recorders do |recorder|
    json.id recorder['recorder_slug']
    json.vendor_id recorder.vendor['vendor_slug']
    json.url api_v1_recorder_url(recorder.recorder_slug, format: :json)
  end
end
