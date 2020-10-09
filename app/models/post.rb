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

  def graphic(width = 225, user = author)
    new_post_type = user == author ? [post_type] : ["Request", "Offer"].delete_if { |x| x == post_type }
    style = "width: #{width}px; height: #{width / 2}px; font-size: #{width / 16}pt"
    "<div class='card-head #{new_post_type[0].downcase}' style='#{style}'>
      <div class='post-icon post-#{new_post_type[0].downcase}'>
        <div class='icon-img-text text-#{new_post_type[0] == 'Offer' ? 'primary' : 'info'}'>
          <i class='#{icon}'></i>
          <div class='icon-text'>#{new_post_type[0] == 'Offer' ? '!' : '?'}</div>
        </div>
        <span class='badge badge-pill badge-secondary m-auto'>#{category.name}</span>
      </div>
      <img src='#{user.img_url}' class='post-card avatar'>
    </div>"
  end

  def header(width = 125, user = author)
    puts "user is #{user.name}"
    puts "location (not user.location) is #{latitude} #{longitude}"
    "<div class='lg-card-head'>
      <div class='lg-card-head graphic'>#{graphic(width, user)}</div>
      <div class='lg-card-head title'>
        <strong>#{title}</strong>
        <span><i class='fas fa-map-marker-alt'></i>
        #{distance_to_user([user.latitude, user.longitude])} to #{user.name}
        </span>
      </div>
    </div>"
  end

  def distance_to_user(user_location)
    puts "user_location: #{user_location}"
    puts "latitude: #{latitude}"
    puts "longitude: #{longitude}"
    puts "distance between: #{Geocoder::Calculations
          .distance_between(user_location, [latitude, longitude])}"
    if [user_location, latitude, longitude].all?
      "#{Geocoder::Calculations
          .distance_between(user_location, [latitude, longitude])
          .floor} km away"
    else
      "near you"
    end
  end

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
