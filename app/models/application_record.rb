class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_page_limit(page, page_size)
    page = 1 if page < 1
    self.limit(page_size).offset((page.to_i - 1) * page_size)
  end
end
