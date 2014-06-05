change ||= @change

json.prettify!
json.id change['id']
json.object_changed change['item_type']
json.object_id change['item_id']
json.object_id change['item_type'].classify.constantize.find(change['item_id'])["#{change['item_type'].downcase}_slug"]
json.object_changes YAML::load(change.object_changes)
json.created_at change['created_at']

if change.class == ActiveRecord::Base && !change.persisted? &&
  !change.valid?
  json.errors change.errors.messages
end
