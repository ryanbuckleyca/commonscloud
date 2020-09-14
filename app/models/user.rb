class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :connections, dependent: :destroy
  validates :name, :email, :address, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  before_save :set_img_url

  private

  def set_img_url
    default_avatar = "https://res.cloudinary.com/ryanbuckleyca/image/upload/v1600109993/user_bgu0at.jpg"
    self.img_url = default_avatar if self.img_url.blank?
  end
end
