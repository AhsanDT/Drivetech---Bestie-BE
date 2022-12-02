require 'open-uri'
class Admins::SupportsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_end_user, only: [:index, :user_chat]
  before_action :find_support_by_id, only: :update_ticket_status

  def index
    @user = @end_users.first
  end

  def new
    @support = SupportMessage.new
  end

  def create
    conversation = current_admin.support_conversations.find_by(id: params[:id])
    if conversation.present?
      @message = conversation.admin_support_messages.new(sender_id: current_admin.id ,body: params[:body],image: params[:file])
      if @message.save
        data = {}
          data["id"] = @message.id
          data["support_conversation_id"] = @message.support_conversation_id
          data["body"] = @message.body
          data["user_id"] = @message.sender_id
          data["sender_id"] = @message.support_conversation.sender.id
          data["recipient_id"] =  @message.support_conversation.recipient.id
          data["created_at_date"] = @message.created_at&.strftime('%b %d, %Y') 
          data["created_at_time"] = @message&.created_at&.strftime('%H:%M%p')
          data["created_at"] = @message.created_at
          data["updated_at"] = @message.updated_at
          data["image"] = @message&.image&.url
          ActionCable.server.broadcast "support_conversations_#{@message.support_conversation_id}", { title: 'chat', body: data.as_json }
          @conversation =  conversation.admin_support_messages.last
      end
    end
  end

  def update_ticket_status
    @support.update(status: params[:status])
    redirect_to user_chat_admins_supports_path(id: params[:id])
  end

  def user_chat
    @user = SupportConversation.find_by(id: params["id"])
    render 'index'
  end

  def download
    @user = UserSupportMessage.find_by(id: params[:id])
    url = url_for(@user.image)
    download = URI.open(url)
    filename = url.to_s.split('/')[-1]
    send_data download.read, disposition: 'attachment', filename: filename
  end

  private

  def find_end_user
    if params[:search].present?
      @end_users = SupportConversation.custom_search(params[:search]).order(created_at: :desc)
    else
      @end_users = SupportConversation.all.order(created_at: :desc)
    end
  end

  def find_support_by_id
    @support = Support.find_by_id(params[:support_id])
    return render json: {
      message: 'Support not found against this id'
    }, status: :unprocessable_entity unless @support.present?
  end
end
