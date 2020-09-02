class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :user_location

  def index
    @posts = Post.geocoded.order('created_at DESC')
    @posts = @posts.where(post_type: params[:type].split(',')) if params[:type].present?
    @posts = @posts.where(category_id: params[:categories].split(',')) if params[:categories].present?

    @markers = @posts.map do |post|
      { lat: post.latitude, lng: post.longitude, icon: "#{post.icon} map-icon text-#{post.color}" }
    end

    stringified_posts = @posts.map { |post| render_to_string partial: "posts/all", formats: [:html], locals: { posts: @posts } }
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
    @category = Category.find(params[:post][:category_id])
    @post.category = @category
    @post.author = current_user

    if @post.save
      redirect_to user_path(current_user, tab: "myposts")
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    if Connection.find_by(post_id: @post.id).present?
      @existing = true
    else
      @existing = false
    end
    @connection = Connection.new
    @markers = [
      { lat: @post.latitude, lng: @post.longitude, icon: "#{@post.icon} map-icon text-#{@post.color}" },
      { lat: @user_location[0], lng: @user_location[1], icon: "fas fa-map-marker-alt map-icon text-#{@post.color == "primary" ? "info" : "primary"}" }
    ]
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_type, :description, :location, :priority)
  end

  def user_location
    if request.key?('HTTP_HOST')
      if request['HTTP_HOST'].nil? || request['HTTP_HOST'].include?("localhost")
        @user_location = [45.525990, -73.595410]
      end
    else
      @user_location = [request.location.longitude, request.location.latitude]
    end
  end
end
