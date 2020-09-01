class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    if params[:tab] == "outgoing" || params[:tab] == "myposts"
      @tab = params[:tab]
    else
      @tab = "incoming"
    end

    @user = current_user.geocoded
    @posts = Post.where(author_id: current_user.id).order('created_at DESC')
    @user_connections = Connection.where(responder_id: current_user.id).order('created_at DESC')
  end
end
