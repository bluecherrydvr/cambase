json.manufacturers do
  json.partial! 'api/v1/manufacturers/manufacturer', manufacturer: @manufacturer
end
