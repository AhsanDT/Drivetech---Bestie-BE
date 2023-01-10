class Api::V1::BookingsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_booking, only: [:update, :send_reschedule, :reschedule, :cancel_booking]
  after_action :notification_worker, only: [:create]

  def create
    @booking = []
    @bestie_booking_timing = []
    params[:start_time].each do |start_time|
      @bestie_booking_timing  << User.find_by(id: params[:send_to_id]).bookings.where("(?) = Any(start_time)", start_time)
    end
    custom_start_time_params = []
    custom_end_time_params = []
    time_array = @bestie_booking_timing.flatten.pluck(:start_time).flatten
    params[:start_time].each_with_index do |start_time,index|
      @check = time_array.include?(start_time)
      if @check == false
        custom_start_time_params << start_time
        custom_end_time_params << params[:end_time][index]
      end
    end
    params[:start_time] = custom_start_time_params
    params[:end_time] = custom_end_time_params
    if params[:start_time].present?
      @booking  = @current_user.bookings.create(booking_params)
      Notification.create(subject: "Booking_#{@booking.id}", body: "You have a new booking", notification_type: "Booking", user_id: @booking.send_to_id, send_by_id: @booking.send_by_id, send_by_name: @booking.send_by.full_name, booking_sender_id: @booking.send_by_id)
    end
    render json: { data: @booking }
  end

  def update
    @booking.update(booking_params)
    if params[:status] == "Accepted"
      booking_duration = (@booking.end_time.last - @booking.start_time.first) / 3600
      @payment = StripeService.create_charge_by_card((((@booking.rate * booking_duration).to_f) * 100).to_i, @current_user.stripe_customer_id)
      current_user_notification = Notification.create(subject: "You #{params[:status]} The Booking", body: "This is added to your calendar you have an upcoming appointment today", user_id: @booking.send_to_id, send_by_id: @booking.send_to_id, send_by_name: @booking.send_to.full_name, notification_type: "UpdateBooking", booking_sender_id: @booking.send_by_id)
      other_user_notification = Notification.create(subject: "Booking Has Been Set!", body: "Your booking with #{@booking.send_to.full_name} has been confirmed.", user_id: @booking.send_by_id, send_by_id: @booking.send_to_id, send_by_name: @booking.send_to.full_name, notification_type: "UpdateBooking", booking_sender_id: @booking.send_by_id)
    elsif params[:status] == "Rejected"
      current_user_notification = Notification.create(subject: "You Denied The Booking", body: "You denied the booking, you can never return this back", user_id: @booking.send_to_id, send_by_id: @booking.send_to_id, notification_type: "UpdateBooking", send_by_name: @booking.send_to.full_name, booking_sender_id: @booking.send_by_id)
      other_user_notification = Notification.create(subject: "Booking Has Been Denied!", body: "#{@booking.send_to.full_name} has canceled your booking.", user_id: @booking.send_by_id, send_by_id: @booking.send_to_id, notification_type: "UpdateBooking", send_by_name: @booking.send_to.full_name, booking_sender_id: @booking.send_by_id)
    end
    render json: {message: "Booking has been #{params[:status]}", data: @booking, payment: @payment}
  end

  def send_reschedule
    if @booking.present?
      if @booking.send_by_id == @current_user.id
        @notification = Notification.create(subject: "Reschedule Booking_#{@booking.id}", body: "#{@booking.send_by.full_name} requests to re-schedule your booking", user_id: @booking.send_to_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, notification_type: "Reschedule Request", booking_sender_id: @booking.send_by_id)
      elsif @booking.send_to_id == @current_user.id
        @notification = Notification.create(subject: "Reschedule Booking_#{@booking.id}", body: "#{@booking.send_by.full_name} requests to re-schedule your booking", user_id: @booking.send_by_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, notification_type: "Reschedule Request", booking_sender_id: @booking.send_by_id)
      end
      render json: { data: @notification }
    else
      render json: { message: "Booking not found"}
    end
  end

  def reschedule
    if @booking.present?
      if params[:status] == "Accepted"
        if @booking.send_by_id == @current_user.id
          @notification = Notification.create(subject: "Accepted Reschedule_#{@booking.id}", body: "Your request to re-schedule your booking has been approved by #{@booking.send_by.full_name}. Wait until your client chooses new date and time.", user_id: @booking.send_to_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, notification_type: "Reschedule Accept", booking_sender_id: @booking.send_by_id)
        elsif @booking.send_to_id == @current_user.id
          @notification = Notification.create(subject: "Accepted Reschedule_#{@booking.id}", body: "Your request to re-schedule your booking has been approved by #{@booking.send_by.full_name}. Wait until your client chooses new date and time.", user_id: @booking.send_by_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, notification_type: "Reschedule Accept", booking_sender_id: @booking.send_by_id)
        end
      elsif params[:status] == "Rejected"
        if @booking.send_by_id == @current_user.id
          @notification = Notification.create(subject: "Rejected Reschedule_#{@booking.id}", body: "Your request to re-schedule your booking has been denied by #{@booking.send_by.full_name}.", user_id: @booking.send_to_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, notification_type: "Reschedule Deny", booking_sender_id: @booking.send_by_id)
        elsif @booking.send_to_id == @current_user.id
          @notification = Notification.create(subject: "Rejected Reschedule_#{@booking.id}", body: "Your request to re-schedule your booking has been denied by #{@booking.send_by.full_name}.", user_id: @booking.send_by_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, notification_type: "Reschedule Deny", booking_sender_id: @booking.send_by_id)
        end
      end
      render json: { data: @notification }
    else
      render json: { message: "Booking not found"}
    end
  end

  def current_user_bookings
    @bookings = Booking.where(send_by_id: @current_user.id).or(Booking.where(send_to_id: @current_user.id))
  end

  def cancel_booking
    if @booking.present?
      @booking_duration = (@booking.end_time.last - @booking.start_time.first) / 3600
      if ((Time.now - @booking.updated_at) / 3600) <= 24
        begin
          @payment = StripePaymentService.create_transfer(((((@booking.rate * @booking_duration).to_f) * 100) / 2).to_i, @current_user.stripe_connect_id)
        rescue => e
          return render json: e.message
        end
        @booking.destroy
        render json: { message: "Booking has been canceled" }
      else
        begin
          @payment = StripePaymentService.create_transfer((((@booking.rate * @booking_duration).to_f) * 100).to_i, @current_user.stripe_connect_id)
        rescue
          return render json: e.message
        end
        @booking.destroy
        render json: { message: "Booking has been canceled" }
      end
    else
      render json: { message: "Booking not found." }
    end
  end

  private

  def booking_params
    params.permit(:id, :rate, :send_by_id, :send_to_id, :status, start_time: [], end_time: [])
  end

  def find_booking
    @booking = Booking.find_by(id: params[:id])
  end

  def notification_worker
    if @booking.present?
      one_hour_worker = NotificationWorker.perform_in((@booking.start_time.first - 1.hours), @booking.send_to_id, "1 Hour Before Your Appointment with #{@booking.send_to.full_name}", @booking.send_by.id, @booking.send_by.full_name, "Pre Reminder", booking_sender_id: @booking.send_by_id )
      half_hour_worker = NotificationWorker.perform_in((@booking.start_time.first - 0.5.hours), @booking.send_to_id, "30 Minutes Before Your Appointment with #{@booking.send_to.full_name}", @booking.send_by.id, @booking.send_by.full_name, "Pre Reminder", booking_sender_id: @booking.send_by_id)
      twenty_minute_worker = NotificationWorker.perform_in((@booking.start_time.first - 20.minutes), @booking.send_to_id, "20 Minutes Before Your Appointment with #{@booking.send_to.full_name}", @booking.send_by.id, @booking.send_by.full_name, "Pre Reminder", booking_sender_id: @booking.send_by_id)
      ten_minutes_worker = NotificationWorker.perform_in((@booking.start_time.first - 10.minutes), @booking.send_to_id, "10 Minutes Before Your Appointment with #{@booking.send_to.full_name}", @booking.send_by.id, @booking.send_by.full_name, "Pre Reminder", booking_sender_id: @booking.send_by_id)
      two_hour_worker = NotificationWorker.perform_in((@booking.end_time.last - @booking.start_time.first), @booking.send_to_id, "#{((@booking.end_time.last - @booking.start_time.first) / 60).to_i}", @booking.send_by.id, @booking.send_by.full_name, "Post Reminder Initial", booking_sender_id: @booking.send_by_id)
      twenty_minutes_worker = NotificationWorker.perform_in((@booking.end_time.last - 20.minutes), @booking.send_to_id, "20", @booking.send_by.id, @booking.send_by.full_name, "Post Reminder Middle", booking_sender_id: @booking.send_by_id)
      zero_minutes_worker = NotificationWorker.perform_in((@booking.end_time.last - 20.minutes), @booking.send_to_id, "0", @booking.send_by.id, @booking.send_by.full_name, "Post Reminder End", booking_sender_id: @booking.send_by_id)
    end
  end
end