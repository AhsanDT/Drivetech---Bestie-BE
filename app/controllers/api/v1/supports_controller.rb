class Api::V1::SupportsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :generate_ticket_number, only: :create

  def index
    @support = @current_user.supports.order("created_at desc")
      # render json: {
      #   message: 'All Support Queries',
      #   data: []
      # }, status: :ok if @support.empty?
    # end
  end

  def create
    @support = @current_user.supports.new(supports_params.merge(ticket_number: generate_ticket_number.upcase))
    if @support.save
      render json: {
        message: 'Support Query created',
        data: @support,
        support_image: @support.image.attached? ? @support.image.blob.url : ''
      }, status: :ok
    else
      render json: {
        message: 'There are errors while creating support query',
        error: @support.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private
  def supports_params
    params.require(:support).permit(:id, :ticket_number, :status, :description, :image)
  end

  def generate_ticket_number
    @ticket_number = loop do
      random_token = (SecureRandom.urlsafe_base64(6, false))
      break random_token unless Support.exists?(ticket_number: random_token)
    end
  end

end
