class Api::V1::BlockUsersController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_user, only: [:create]
  before_action :find_blocked_user, only: [:create]

  def create
    if @user.present?
      return render json: { message: "User is already blocked"} unless !@blocked_user.present?
      @block_user = BlockUser.create(blocked_user_id: params[:block_user_id], blocked_by_id: @current_user.id)
      @conversation = Conversation.where(sender_id: params[:block_user_id], recipient_id: @current_user.id).or(Conversation.where(sender_id: @current_user.id, recipient_id: params[:block_user_id]))
      if @conversation.present?
        @conversation.update(is_blocked: true)
        render json: { message: "User has been blocked", data: @block_user }
      else
        render json: {message: "This conversation is not present"}
      end
    else
      render json: { message: "This user does not exist"}
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @blocked_user = BlockUser.find_by(blocked_user_id: @user.id, blocked_by_id: @current_user.id)
    if @user.present?
      if @blocked_user.present?
        @blocked_user.destroy
        render json: { message: "User has been unblocked" }
      else
        render json: { message: "This user is not blocked" }
      end
    else
      render json: { message: "This user does not exist" }
    end
  end

  def index
    @blocked_users = @current_user.blocked_users
    render json: { message: "Current user blocked users", data: @blocked_users }
  end
  
  private

  def find_user
    @user = User.find_by(id: params[:block_user_id])
  end

  def find_blocked_user
    @blocked_user = BlockUser.find_by(blocked_user_id: params[:block_user_id], blocked_by_id: @current_user.id)
  end
end