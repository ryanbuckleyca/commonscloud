class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:message][:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user

    # if @message.save
    #   redirect_to user_path(current_user)
    # else
    #   render 'new'
    # end

    if @message.save!
      ChatroomChannel.broadcast_to(
        @chatroom,
        message: render_to_string(partial: "message", locals: { message: @message }), chatroom_id: @chatroom.id
      )
        create_notification(@message)
      # message_container_html = render_to_string(partial: "message_container", formats: [:html], locals: { messages: messages })
      # render json: { success: true, message_container_html: message_container_html }
    else
      # message_form_html = render_to_string(partial: "message_form", formats: [:html], locals: { current_user: current_user })
      # render json: { success: false, message_form_html: message_form_html }
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :connection_id)
  end

  def create_notification(message)
    sender = message.user
    user_one = message.connection.responder
    user_two = message.connection.post.author
    receiver = sender == user_one ? user_two : user_one
    Notification.create!(user: receiver, message: message)
  end
end
