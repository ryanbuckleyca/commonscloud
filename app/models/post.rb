class Post < ApplicationRecord
  belongs_to :category
  belongs_to :author, class_name: 'User'
  has_many :connections, dependent: :destroy

  def distance_from_user
  end

  def icon
    case category.name
    when "tools" then '<i class="fas fa-tools"></i>'
    when "tech help" then '<i class="fas fa-desktop"></i>'
    when "medicine" then '<i class="fas fa-heartbeat"></i>'
    when "ppe" then '<i class="fas fa-head-side-mask"></i>'
    when "hygiene supplies" then '<i class="fas fa-hands-wash"></i>'
    when "food" then '<i class="fas fa-apple-alt"></i>'
    when "transportation" then '<i class="fas fa-shuttle-van"></i>'
    when "errands" then '<i class="fas fa-running"></i>'
    when "deliveries" then '<i class="fas fa-dolly"></i>'
    when "clothing" then '<i class="fas fa-tshirt"></i>'
    when "financial support" then '<i class="fas fa-donate"></i>'
    when "school supplies" then '<i class="fas fa-graduation-cap"></i>'
    when "shelter" then '<i class="fas fa-house-user"></i>'
    when "cleaning supplies" then '<i class="fas fa-quidditch"></i>'
    when "household supplies" then '<i class="fas fa-chair"></i>'
    when "emotional support" then '<i class="fas fa-comments"></i>'
    end
  end

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
