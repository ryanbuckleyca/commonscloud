class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :connections, dependent: :destroy
  has_many :users, through: :connections
end
