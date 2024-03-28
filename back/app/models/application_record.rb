class ApplicationRecord < ActiveRecord::Base
  include Paginate

  self.abstract_class = true
end
