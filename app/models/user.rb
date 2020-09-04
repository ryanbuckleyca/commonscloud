class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :notifications, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def unread_notifications
    self.notifications.select { |notif| notif.unread }.count
  end

end
