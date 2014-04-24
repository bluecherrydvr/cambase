json.cameras @cameras, partial: 'api/v1/cameras/camera', as: :camera
json.total_count @cameras.respond_to?(:total_entries) ?
@cameras.total_entries : @cameras.to_a.count
