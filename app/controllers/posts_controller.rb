class PostsController < ApplicationController
  def index
    if params[:query].present?
      @posts = Post.where(post_type: params[:query])
    else
      @posts = Post.all
    end
  end

  def new
  end

  def create
  end

  def show
    @post = Post.find(params[:id])
  end
end
