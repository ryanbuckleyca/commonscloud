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
    room_name = [connection.author.name, connection.responder.name].sort.join

    @chatroom = Chatroom.find_by_name(room_name) ? Chatroom.find_by_name(room_name) : Chatroom.new(name: room_name)

    # SET INITIAL MSG
    @initial_msg = @connection.message
    @initial_msg += "I'm interested in #{link_to post.title, post_path(@post)}:"

    @message = Message.new(content: @initial_msg)
    @message.user = connection.responder
    @message.chatroom = @chatroom
    @message.save!

    # RESPONSE MSG
    @responder_msg = "Thanks for the message, I'll be in touch soon."
    @message = Message.new(content: @responder_msg)
    @message.user = connection.author
    @message.chatroom = @chatroom
    @message.save!
  end

  def update
  end

  private

  def connection_params
    params.require(:connection).permit(:status, :message)
  end
end
