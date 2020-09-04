class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user
  belongs_to :connection
  has_many :notifications, dependent: :destroy

end
