class Post < ApplicationRecord
  belongs_to :category
  belongs_to :author, class_name: 'User'
  has_many :connections, dependent: :destroy

  def color
    case priority
    when "High" then 'danger'
    when "Medium" then 'warning'
    when "Low" then 'info'
    else 'primary'
    end
  end

  def icon
    category.icon
  end

  def punctuation
    if post_type == "Request"
      "<p>#{['Medium', 'High'].include?(priority) ? '?' : ' '}</p>
       <p class='pl-3'>?</p>
       <p class='pl-4 pt-1'>#{priority == 'High' ? '?' : ' '}</p>"
    elsif post_type == "Offer"
      "<p class='offer'>!</p>"
    end
  end

  def graphic
    "<div class='card-head #{post_type.downcase}'>
      <div class='post-icon post-#{post_type.downcase}'>
        <div class='icon-img-text text-#{color}'>
          <i class='#{icon}'></i>
          <div class='icon-text'>#{punctuation}</div>
        </div>
        <span class='badge badge-pill badge-secondary m-auto'>#{category.name}</span>
      </div>
      <img src='#{author.img_url}' class='post-card avatar'>
    </div>"
  end

  def header
    "<div class='lg-card-head'>
      <div class='lg-card-head graphic'>#{graphic}</div>
      <div class='lg-card-head title #{post_type}'>
        <h3>#{title}</h3>
        <p>TODO UPDATE MODEL: distance between USER and POST <-- hardcoded in post.rb</p>
      </div>
    </div>"
  end

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
