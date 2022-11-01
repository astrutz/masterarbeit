module Receive
  class MessagesController < ApplicationController
    before_action :authorize
    def show
      @message = Message.find(params[:id])
    end

def destroy
  message = Message.find(params[:id])
  if params[:fetch].nil?
    EmailServices.establish_connection(current_user.credential)
    EmailServices.read_message(message)
  end
  message.processed_at = Time.now
  message.save
  redirect_to receive_root_path
end
  end
end