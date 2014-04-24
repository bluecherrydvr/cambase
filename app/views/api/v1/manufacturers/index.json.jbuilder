json.manufacturers @manufacturers, partial: 'api/v1/manufacturers/manufacturer', as: :manufacturer
json.total_count @manufacturers.respond_to?(:total_entries) ?
@manufacturers.total_entries : @manufacturers.to_a.count
