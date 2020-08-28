class UsersController < ApplicationController
  def update

  end

  def show
    @user = current_user
    @posts = Post.where(author_id: current_user.id)
    @post_connection = @posts.connection
    @user_connections = Connection.where(responder_id: current_user.id)
  end
end
