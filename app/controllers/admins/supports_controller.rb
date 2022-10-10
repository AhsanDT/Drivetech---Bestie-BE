require 'open-uri'
class Admins::SupportsController < ApplicationController
  before_action :find_end_user, only: [:index, :user_chat]
  before_action :authenticate_admin!

  def index
    @user = @end_users.first
  end

  def new
    @support = SupportMessage.new
  end

  def create
    conversation = current_admin.support_conversations.find_by(id: params[:id])
    if conversation.present?
      @message = conversation.admin_support_messages.new(sender_id: current_admin.id ,body: params[:body],image: params[:image])
      if @message.save
        data = {}
          data["id"] = @message.id
          data["support_conversation_id"] = @message.support_conversation_id
          data["body"] = @message.body
          data["user_id"] = @message.sender_id
          data["sender_id"] = @message.support_conversation.sender.id
          data["receiver_id"] =  @message.support_conversation.receiver.id
          data["created_at"] = @message.created_at
          data["updated_at"] = @message.updated_at
          data["image"] = @message&.image&.url
          data["message_type"] = @message.type
          ActionCable.server.broadcast "support_conversations_#{@message.support_conversation_id}", { title: 'chat', body: data.as_json }
          @conversation =  conversation.admin_support_messages.last
      end
    end
  end

  def user_chat
    @user = SupportConversation.find_by(id: params["id"])
    render 'index'
  end

  # def download
  #   @user = UserSupportMessage.find_by(id: params[:id])
  #   url = url_for(@user.image)
  #   download = URI.open(url)
  #   filename = url.to_s.split('/')[-1]
  #   send_data download.read, disposition: 'attachment', filename: filename
  # end

  private

  def find_end_user
    @end_users = SupportConversation.all.order(created_at: :desc)
  end
end
