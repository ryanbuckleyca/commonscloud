class ConnectionsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @connection = Connection.new(connection_params)
    @connection.responder = current_user
    @connection.post = @post

    if @connection.save
      redirect_to user_path(current_user, tab: "outgoing")
    else
      flash.alert = 'Oops.. something went wrong. Please try again.'
    end

    initiate_chat
  end

  def initiate_chat
    room_name = [@connection.post.author.id, @connection.responder.id].sort.join('-')
    @chatroom = Chatroom.find_by_name(room_name) || Chatroom.new(name: room_name)
    @initial_msg = "<span class='chat-alert'>new connection via
                    <a href='#{post_path(@post)}'>#{@post.title}</a></span>"
    @initial_msg += @connection.message
    @message = Message.create!(content: @initial_msg, user: @connection.responder, chatroom: @chatroom)
    @responder_msg = "Thanks for the message, I'll be in touch soon."
    @message = Message.create!(content: @responder_msg, user: @connection.post.author, chatroom: @chatroom)
  end

  def update
  end

  private

  def connection_params
    params.require(:connection).permit(:status, :message)
  end
end
