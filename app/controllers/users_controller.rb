class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    gon.current_user_id = current_user.id

    if params[:tab] == "myposts"
      @tab = "myposts"
    else
      @tab = "incoming"
    end

    @message = Message.new

    @user = current_user
    @posts = Post.where(author: @user).order('created_at DESC')
    @user_connections = Connection.where(responder: @user)
                                  .or(Connection.where(post: @posts))
                                  .order('created_at DESC')
  end
end
