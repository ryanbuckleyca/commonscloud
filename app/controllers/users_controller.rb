class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update

  end

  def show
    @user = current_user
    @posts = Post.where(author_id: current_user.id).order('created_at DESC')
    @user_connections = Connection.where(responder_id: current_user.id).order('created_at DESC')
  end
end
