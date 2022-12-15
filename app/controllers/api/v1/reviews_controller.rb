class Api::V1::ReviewsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_booking, only: [:create]
  before_action :find_bookings, only: [:index]

  def create
    if @booking.present?
      if @current_user.profile_type == "bestie" || "Bestie"
        @review = BestieReview.create(review_params.merge(review_to_id: @booking.send_to_id, review_by_id: @current_user.id))
      else
        @review = UserReview.create(review_params.merge(review_to_id: @booking.send_to_id, review_by_id: @current_user.id))
      end
    else
      render json: {message: "This booking is not present"}
    end
  end

  def index
    @review_rating = 0
    @reviews.each do |review|
      @review_rating  += review.rating
    end
    @review_average_rating = @review_rating / @current_user.reviews.count
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