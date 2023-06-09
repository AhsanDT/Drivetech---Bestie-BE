class Api::V1::ReviewsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_booking, only: [:create]
  before_action :find_bookings, only: [:index]

  def create
    if @booking.present?
      if @current_user.profile_type == "bestie" || "Bestie"
        if @booking.send_to_id == @current_user.id
          @review = BestieReview.create(review_params.merge(review_to_id: @booking.send_by_id, review_by_id: @current_user.id))
          Notification.create(subject: "Review", body: "#{@current_user.full_name} gave you feedback and posted a review on your profile.", notification_type: "Review", user_id: @booking.send_by_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, booking_sender_id: @booking.send_by_id)
        elsif @booking.send_by_id == @current_user.id
          @review = BestieReview.create(review_params.merge(review_to_id: @booking.send_to_id, review_by_id: @current_user.id))
          Notification.create(subject: "Review", body: "#{@current_user.full_name} gave you feedback and posted a review on your profile.", notification_type: "Review", user_id: @booking.send_to_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, booking_sender_id: @booking.send_by_id)
        end
      else
        if @booking.send_to_id == @current_user.id
          @review = UserReview.create(review_params.merge(review_to_id: @booking.send_by_id, review_by_id: @current_user.id))
          Notification.create(subject: "Review", body: "#{@current_user.full_name} gave you feedback and posted a review on your profile.", notification_type: "Review", user_id: @booking.send_by_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, booking_sender_id: @booking.send_by_id)
        elsif @booking.send_by_id == @current_user.id
          @review = UserReview.create(review_params.merge(review_to_id: @booking.send_to_id, review_by_id: @current_user.id))
          Notification.create(subject: "Review", body: "#{@current_user.full_name} gave you feedback and posted a review on your profile.", notification_type: "Review", user_id: @booking.send_to_id, send_by_id: @current_user.id, send_by_name: @current_user.full_name, booking_sender_id: @booking.send_by_id)
        end
      end
    else
      render json: {message: "This booking is not present"}
    end
  end

  def index
    if @reviews.present?
      @review_rating = 0
      @reviews.each do |review|
        @review_rating  += review.rating
      end
      @review_average_rating = @review_rating / @current_user.reviews.count
    else
      render json: {message: "No reviews found"}
    end
  end

  def pending_reviews
    @bookings = Booking.where(send_by_id: @current_user.id).where.missing(:review)
  end

  private

  def review_params
    params.permit(:id, :rating, :description, :review_by_id, :review_to_id, :booking_id, images: [])
  end

  def find_booking
    @booking = Booking.find_by(id: params[:booking_id])
  end

  def find_bookings
    @reviews = @current_user.reviews
  end
end