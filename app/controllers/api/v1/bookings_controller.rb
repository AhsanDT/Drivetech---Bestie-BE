class Api::V1::BookingsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_booking, only: [:update]

  def create
    @booking = @current_user.bookings.create(booking_params)
    Notification.create(subject: "Booking", body: "Booking has been created", user_id: @current_user.id)
    render json: { data: @booking }
  end

  def update
    @booking.update(status: params[:status])
    Notification.create(subject: "Booking #{params[:status]}", body: "Booking has been #{params[:status]}", user_id: @current_user.id)
    render json: {message: "Booking has been #{params[:status]}", data: @booking}
  end

  def destroy

  end

  def index
    
  end

  private

  def booking_params
    params.permit(:id, :date, :rate, :send_by_id, :send_to_id, :status, time: [])
  end

  def find_booking
    @booking = Booking.find_by(id: params[:id])
  end
end