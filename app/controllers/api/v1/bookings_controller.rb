class Api::V1::BookingsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_booking, only: [:update]

  def create
    @booking = @current_user.bookings.create(booking_params)
    Notification.create(subject: "Booking", body: "You have a new booking", user_id: @current_user.id)
    one_hour_worker = NotificationWorker.perform_in((@booking.start_time - 1.hours), @booking.send_to.id, @current_user.id, "One")
    half_hour_worker = NotificationWorker.perform_in((@booking.start_time - 0.5.hours), @booking.send_to.id, @current_user.id, "Half")
    half_hour_worker = NotificationWorker.perform_in((@booking.start_time - 20.minutes), @booking.send_to.id, @current_user.id, "20 minutes")
    half_hour_worker = NotificationWorker.perform_in((@booking.start_time - 10.minutes), @booking.send_to.id, @current_user.id, "10 minutes")
    render json: { data: @booking }
  end

  def update
    @booking.update(booking_params)
    Notification.create(subject: "Booking #{params[:status]}", body: "Booking has been #{params[:status]}", user_id: @current_user.id)
    render json: {message: "Booking has been #{params[:status]}", data: @booking}
  end

  def destroy

  end

  def index
    
  end

  private

  def booking_params
    params.permit(:id, :date, :rate, :send_by_id, :send_to_id, :status, :start_time, :end_time, time: [])
  end

  def find_booking
    @booking = Booking.find_by(id: params[:id])
  end
end