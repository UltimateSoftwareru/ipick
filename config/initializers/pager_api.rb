PagerApi.setup do |config|
  # config.pagination_handler = :will_paginate
  config.include_pagination_on_meta = true
  config.include_pagination_headers = false
end
