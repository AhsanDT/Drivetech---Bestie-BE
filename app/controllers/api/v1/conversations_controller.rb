class Api::V1::ConversationsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_conversation, only: [:create_message]


  def create
    if Conversation.find_by(sender_id: @current_user.id ,recipient_id: params[:recipient_id]).present?
      render json: { message: "Conversation has already been created!" }
    else
      @conversation = Conversation.create!(sender_id: @current_user.id, recipient_id: params[:recipient_id])
      render json: {
        message: "Conversation has been created",
        data: @conversation
      }, status: :ok
    end
  end

  def index
    @conversations = Conversation.find_by(sender_id: @current_user.id)
    render json: {
      message: "Current user conversations",
      data: @conversations
    }
  end

  def destroy
    @conversation = Conversation.find_by(id: params[:id])
    @conversation.destroy
    render json: { message: "Conversation has been deleted" }
  end

  def create_message
    @message = @current_user.messages.create(message_params)
    @message.user_id = @current_user.id
    render json: { message: @message}
  end

  def get_messages
    @conversation = Conversation.find_by(id: params[:conversation_id])
    @messages = Message.where(conversation_id: @conversation.id).order(created_at: :desc)
    render json: {data: @messages}
    render json: { message: 'No messages found', data: [] }, status: :ok if @messages.nil?
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id, :conversation_id)
  end

  def find_conversation
    @conversation = Conversation.find_by(id: params[:conversation_id])
  end
end