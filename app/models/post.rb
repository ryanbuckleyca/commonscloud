class Post < ApplicationRecord
  belongs_to :category
  belongs_to :author, class_name: 'User'
  has_many :connections, dependent: :destroy

  def color
    post_type == 'Offer' ? 'primary' : 'info'
  end

  def icon
    category.icon
  end

  def graphic(width = 225)
    style = "width: #{width}px; height: #{width / 2}px; font-size: #{width / 16}pt"
    "<div class='card-head #{post_type.downcase}' style='#{style}'>
      <div class='post-icon post-#{post_type.downcase}'>
        <div class='icon-img-text text-#{color}'>
          <i class='#{icon}'></i>
          <div class='icon-text'>#{post_type == 'Offer' ? '!' : '?'}</div>
        </div>
        <span class='badge badge-pill badge-secondary m-auto'>#{category.name}</span>
      </div>
      <img src='#{author.img_url}' class='post-card avatar'>
    </div>"
  end

  def header(width = 125)
    "<div class='lg-card-head #{post_type.downcase}'>
      <div class='lg-card-head graphic'>#{graphic(width)}</div>
      <div class='lg-card-head title'>
        <strong>#{title}</strong>
        <p>TODO UPDATE MODEL: distance between USER and POST <-- hardcoded in post.rb</p>
      </div>
    </div>"
  end

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
