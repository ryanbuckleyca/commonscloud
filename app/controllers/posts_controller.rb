class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

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
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @connection = Connection.new
    @marker = { lat: @post.latitude, lng: @post.longitude }
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_type, :description, :location, :priority)
  end
end
