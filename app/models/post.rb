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
    category.icon
  end

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
