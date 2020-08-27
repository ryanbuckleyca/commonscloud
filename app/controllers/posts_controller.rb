class PostsController < ApplicationController
  def index

    @posts = Post.geocoded.near('Montreal', 50)

    @markers = @posts.map do |post|
      {
      lat: post.latitude,
      lng: post.longitude
      }
    end

    if params[:query].present?
      @posts = Post.where(post_type: params[:query])
    else
      @posts = Post.all
    end
  end

  def new
    @post = Post.new
    @category = Category.new
  end

  def create
    @post = Post.new(post_params)
    @category = Category.find(params[:post][:category_id])
    @post.category = @category
    @post.author = current_user

    if @post.save
      redirect_to post_path(@post)
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
    params.require(:post).permit(
      :title, :post_type, :description, :location, :priority)
  end
end

