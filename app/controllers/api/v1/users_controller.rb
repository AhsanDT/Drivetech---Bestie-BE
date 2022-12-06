class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_nearby_users, only: [:suggested_besties, :besties_near_you, :home]

  def home
    @suggested_besties = User.where.not(id: @current_user.id).joins(:subscriptions).uniq
    @suggested_besties = (@suggested_besties & @nearby_users)

    @besties_near_you = User.where.missing(:subscriptions)
    @besties_near_you = (@besties_near_you & @nearby_users)
  end

  def suggested_besties
    @besties = User.where.not(id: @current_user.id).joins(:subscriptions).uniq
    @besties = (@besties & @nearby_users)
  end

  def besties_near_you
    @besties = User.where.missing(:subscriptions)
    @besties = (@besties & @nearby_users)
  end

  def search
    @besties = besties.custom_search(params[:search])
    @besties.each do |bestie|
      @current_user.recent_users.find_or_create_by(recent_user_id: bestie.id)
    end
  end

  def recent_besties
    @besties = RecentUser.all
  end

  def filter
    @besties = besties.where(param_clean(filter_params))
    @besties = @besties.includes(:user_interests).where(user_interests: {interest_id: params[:interest_id]})  if params[:interest_id].present?
    @besties = @besties.includes(:camera_detail).where(camera_detail: {camera_type: params[:camera_type]}) if params[:camera_type].present?
  end

  private

  def find_nearby_users
    @nearby_users = User.in_range(1..1000, units: :miles, origin: [@current_user.latitude, @current_user.longitude])
  end

  def besties
    User.bestie_users
  end

  def filter_params
    params.permit(:location, :age, :sex)
  end
end