class PostsController < ApplicationController
  binding.pry
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :current_user_location

  def index
    @current_user_location = current_user_location
    @posts = Post.near(@current_user_location, 50)
    @posts = @posts.geocoded.order('created_at DESC')
    @posts = @posts.where.not(author: current_user) if current_user
    @posts = @posts.where(post_type: params[:type].split(',')) if params[:type].present?
    @posts = @posts.where(category_id: params[:categories].split(',')) if params[:categories].present?
    @markers = @posts.map do |post|
      { lat: post.latitude, lng: post.longitude, icon: "#{post.icon} map-icon text-#{post.color}" }
    end
    stringified_posts = @posts.map { |post| render_to_string partial: "posts/all", formats: [:html] }
    respond_to do |format|
      format.html
      format.json { render json: { posts: stringified_posts, markers: @markers } }
    end
  end

  def new
    @post_type = params[:type]
    @post = Post.new
    @category = Category.new
  end

  def create
    @post = Post.new(post_params)
    @category = Category.find(params[:categories])
    @post.category = @category
    @post.author = current_user

    if @post.save
      redirect_to user_path(current_user, tab: "myposts")
    else
      render :new
    end
  end

  def show
    puts "def show: method show called from posts controller"
    @current_user_location = current_user_location
    puts "def show: @current_user_location is #{current_user_location}"
    puts "def show: params[:id] is #{params[:id]}"
    @post = Post.find(params[:id])
    puts "def show: Post.find(params[:id]) is #{@post}"
    # sometimes, the ID being returned is the "icon.png"
    # the 'posts#index' page links to correct URL /posts/21
    # and Post.find(id:21) does exist in DB
    # but controller is trying to load id:logo.png
    # only happens in Prod, not in local Dev env
    # might have to do with current_user_location method
    # since that is the main difference bt Prod and Dev here 
    @existing = Connection.find_by(post_id: @post.id).present?
    @connection = Connection.new
    @markers = [
      { lat: @post.latitude, lng: @post.longitude, icon: "#{@post.icon} map-icon text-#{@post.color}" },
      { lat: @current_user_location[0], lng: @current_user_location[1], icon: "fas fa-map-marker-alt map-icon text-#{@post.color == 'primary' ? 'info' : 'primary'}" }
    ]
    puts "def show: @markers is #{@markers}"
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_type, :description, :location, :priority)
  end

  def current_user_location
    return [current_user.latitude, current_user.longitude] if current_user

    # if user is not logged in, get browser geoloc, otherwise default to La Gare
    puts "def current_user_location: user is not logged in"
    puts "def current_user_location: @post.id at this point is #{@post.id}"
    puts "def current_user_location: params[:id] at this point is #{params[:id]}"
    if request.key?('HTTP_HOST')
      if request['HTTP_HOST'].nil? || request['HTTP_HOST'].include?("localhost")
        @current_user_location = [45.525990, -73.595410]
      end
    else
      @current_user_location = [request.location.latitude, request.location.longitude]
    end
  end
end
