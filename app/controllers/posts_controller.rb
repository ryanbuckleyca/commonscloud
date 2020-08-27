class PostsController < ApplicationController
  def index
    @posts = Post.all
    if params[:query].present?
      @posts = @posts.where(post_type: params[:query])
    end

    if params[:category_id].present?
      @posts = @posts.where(category_id: params[:category_id])
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
  end

  private

  def post_params
    params.require(:post).permit(
      :title, :post_type, :description, :location, :priority)
  end
end
