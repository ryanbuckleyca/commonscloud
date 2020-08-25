class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :posts, through: :connections
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
