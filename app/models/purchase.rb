class Purchase < ActiveRecord::Base
  belongs_to :movie
  belongs_to :buyer, class_name: 'User'
end
