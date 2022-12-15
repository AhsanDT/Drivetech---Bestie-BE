class Api::V1::ConversationsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_conversation, only: [:change_read_status, :get_unread_messages]

  def create
    if Conversation.find_by(sender_id: @current_user.id ,recipient_id: params[:recipient_id]).present?
      render json: { message: "Conversation has already been created!" }, status: :unprocessable_entity
    else
      @conversation = Conversation.create!(sender_id: @current_user.id, recipient_id: params[:recipient_id])
      render json: {
        message: "Conversation has been created",
        data: @conversation
      }, status: :ok
    end
  end

  def index
    @conversations = Conversation.where(sender_id: @current_user.id)
  end

  def destroy
    @conversation = Conversation.find_by(id: params[:id])
    if @conversation.present?
      @conversation.destroy
      render json: { message: "Conversation has been deleted" }
    else
      render json: { message: "This conversation is not present" }, status: :not_found
    end
  end

  def create_message
    @message = @current_user.messages.create(message_params)
    @message.user_id = @current_user.id
    @conversation = Conversation.find_by(id: params[:message][:conversation_id])
    @count = @conversation.messages.where(is_read: false).count
    Notification.create(subject: "Message", body: "You have a new message", user_id: @current_user.id)
  end

  def get_messages
    @conversation = Conversation.find_by(id: params[:conversation_id])
    @count = @conversation.messages.where(is_read: false).count
    if @conversation.present?
      @messages = Message.where(conversation_id: @conversation.id).order(created_at: :desc)
      render json: { message: 'No messages found', data: [] }, status: :ok if @messages.nil?
    else
      render json: { message: "This conversation is not present" }, status: :not_found
    end
  end

  def change_read_status
    if @conversation.present?
      @conversation.messages.where.not(id: @current_user.id).update_all(is_read: true)
    else
      render json: { message: "Conversation is not present." }
    end
  end

  def get_unread_messages
    @count = @conversation.messages.where(is_read: false).count
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id, :conversation_id, :image)
  end

  def find_conversation
    @conversation = Conversation.find_by(id: params[:conversation_id])
  end
end