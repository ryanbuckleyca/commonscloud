class Post < ApplicationRecord
  belongs_to :category
  belongs_to :author, class_name: 'User'
  has_many :connections, dependent: :destroy

  def color
    if post_type == "Request" && priority == "High"
      'danger'
    elsif post_type == "Request" && priority == "Medium"
      'warning'
    elsif post_type == "Request" && priority == "Low"
      'info'
    else
      'primary'
    end
  end

  def icon
    case category.name
    when "tools" then 'fas fa-tools'
    when "tech help" then 'fas fa-desktop'
    when "medicine" then 'fas fa-heartbeat'
    when "ppe" then 'fas fa-head-side-mask'
    when "hygiene supplies" then 'fas fa-hands-wash'
    when "food" then 'fas fa-apple-alt'
    when "transportation" then 'fas fa-shuttle-van'
    when "errands" then 'fas fa-running'
    when "deliveries" then 'fas fa-dolly'
    when "clothing" then 'fas fa-tshirt'
    when "financial support" then 'fas fa-donate'
    when "school supplies" then 'fas fa-graduation-cap'
    when "shelter" then 'fas fa-house-user'
    when "cleaning supplies" then 'fas fa-quidditch'
    when "household supplies" then 'fas fa-chair'
    when "emotional support" then 'fas fa-comments'
    end
  end

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
