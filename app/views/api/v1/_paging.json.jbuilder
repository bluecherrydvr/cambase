json.paging do
  unless object.last_page?
    json.next_page_url "#{path}?page=#{object.next_page}"
  end
  json.total_items object.total_count
  json.number_of_pages object.total_pages
  json.items_per_page Kaminari.config.default_per_page
  unless object.first_page?
    json.prev_page_url "#{path}?page=#{object.prev_page}"
  end
  json.current_page object.current_page
end
