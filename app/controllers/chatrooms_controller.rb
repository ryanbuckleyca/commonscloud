class ChatroomsController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end
end
