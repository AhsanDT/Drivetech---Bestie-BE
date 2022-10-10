class Api::V1::SupportConversationsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_conversation_by_support_id, only: :create
  before_action :find_support_conversation, only: [:create_message, :get_messages]

  def create
    if @conversation.present?
      render json: { conversation: @conversation }
    else
      support = Support.find_by(id: params[:support_id])
      if support.present?
        @conversation = @current_user.support_conversations.create(
          support_id: params[:support_id],
          sender_id: @current_user.id,
          recipient_id: Admin.last.id
        )
        if @conversation.save
          render json: {
            message: "support conversation created successfully",
            support_conversation: @conversation
          }, status: :ok
        else
          render json: {
            message: 'There are errors while creating support conversation',
            error: @conversation.errors.full_messages
          }, status: :unprocessable_entity
        end
      else
        render json: { message: "support id not found" }, status: 404
      end
    end
  end

  def index
    return render json: {
       message: "User not have any support conversation"
      }, staus: 404 unless @current_user.support_conversations.present?

    conversations = @current_user.support_conversations
    render json: { message: "All support conversations", conversations: conversations}, status: :ok
  end

  def destroy
    @conversation = SupportConversation.find_by(id: params[:id])

    if @conversation.present?
      @conversation.destroy
      render json: { message: "support conversation is successfully deleted" }, status: :ok
    else
      render json: { message: "support conversation not found" }, status: 404
    end
  end

  def create_message
    if @support_conversation.present?
      @message = @support_conversation.user_support_messages.new(message_params)
      @message.sender_id = @current_user.id
      if @message.save
        data = {}
          data["id"] = @message.id
          data["support_conversation_id"] = @message.support_conversation_id
          data["body"] = @message.body
          data["sender_id"] = @message.support_conversation.sender.id
          data["recipient_id"] = @message.support_conversation.recipient_id
          data["created_at"] = @message.created_at
          data["updated_at"] = @message.updated_at
          data["image"] = @message&.image&.url
          data["user_id"] = @message.sender_id
          data["user_profile"] = @message&.sender&.image&.url
          data["message_type"] = @message.type
          ActionCable.server.broadcast "support_conversations_#{@message.support_conversation_id}", { title: 'dsadasdas', body: data.as_json }
      end
      render json: { message: @message}
    else
      render json: { message: "support conversation id not found"}, status: 404
    end
  end

  def get_messages
    if @support_conversation.present?
      messages = UserSupportMessage.where(sender_id: @current_user.id).order(created_at: :desc)
      render json: { messages: messages }, status: :ok
    else
      render json: { message: "user not have any message" }, status: 404
    end
  end


  # def get_all_support_messages
  #   if @support_conversation.present?
  #     messages = SupportMessage.where(support_conversation_id: @support_conversation.id).order(created_at: :desc)
  #     render json: {
  #       messages: ActiveModel::Serializer::CollectionSerializer.new(
  #       messages,
  #       serializer: SupportConversationSerializer
  #       )
  #     }, status: :ok
  #   else
  #     render json: { message: "support conversation not found" }, status: 404
  #   end
  # end

  private

  def find_conversation_by_support_id
    @conversation = SupportConversation.find_by(support_id: params[:support_id])
  end

  def find_support_conversation
    @support_conversation = SupportConversation.find_by(id: params[:support_conversation_id])
  end

  def message_params
    params.require(:message).permit(:body, :image, :support_conversation_id)
  end
end
