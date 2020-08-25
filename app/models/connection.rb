class Connection < ApplicationRecord
  belongs_to :responder, class_name: 'User'
  belongs_to :post
end
