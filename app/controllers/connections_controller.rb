class ConnectionsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @connection = Connection.new(connection_params)
    @connection.responder = current_user
    @connection.post = @post

    if @connection.save
      redirect_to user_path(current_user, tab: "outgoing"), notice:
      "Your message was sent to #{@post.author.name}.
      # You can now contact him at #{@post.author.email}"
    else
      flash.alert = 'Ops.. something went wrong. Please try again.'
    end
  end

  def update
  end

  private

  def connection_params
    params.require(:connection).permit(:status, :message)
  end
end
