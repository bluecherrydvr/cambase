json.prettify!
json.partial! 'api/v1/metadata'
json.data do |data|
  json.partial! 'api/v1/paging', object: @changes, path: api_v1_changes_url
  json.changes @changes, partial: 'api/v1/changes/change', as: :change
end
