class PostsController < ApplicationController
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
    @current_user_location = current_user_location
    @post = Post.find(params[:id])
    @existing = Connection.find_by(post_id: @post.id).present? if @post
    @connection = Connection.new
    @markers = [
      { lat: @post.latitude, lng: @post.longitude, icon: "#{@post.icon} map-icon text-#{@post.color}" },
      { lat: @current_user_location[0], lng: @current_user_location[1], icon: "fas fa-map-marker-alt map-icon text-#{@post.color == 'primary' ? 'info' : 'primary'}" }
    ]
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_type, :description, :location, :priority)
  end

  def current_user_location
    return [current_user.latitude, current_user.longitude] if current_user

    # if user is not logged in, get browser geoloc, otherwise default to La Gare
    if request.key?('HTTP_HOST')
      if request['HTTP_HOST'].nil? || request['HTTP_HOST'].include?("localhost")
        @current_user_location = [45.525990, -73.595410]
      end
    else
      @current_user_location = [request.location.latitude, request.location.longitude]
    end
  end
end
