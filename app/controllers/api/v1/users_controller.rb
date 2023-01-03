
class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_nearby_users, only: [:suggested_besties, :besties_near_you, :home]

  def home
    @suggested_besties = User.where.not(id: @current_user.id).joins(:subscriptions).uniq
    @suggested_besties = (@suggested_besties & @nearby_users).first(3)

    @besties_near_you = User.where.missing(:subscriptions)
    @besties_near_you = (@besties_near_you & @nearby_users).first(3)
  end

  def suggested_besties
    if params[:type] == "suggested_besties"
      @besties = User.where.not(id: @current_user.id).joins(:subscriptions).uniq
    elsif params[:type] == "besties_near_you"
      @besties = User.where.missing(:subscriptions)
    end
    @besties = (@besties & @nearby_users)
  end

  # def besties_near_you
  #   @besties = User.where.missing(:subscriptions)
  #   @besties = (@besties & @nearby_users)
  # end

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
    if !params[:location].present? && !params[:age].present? && !params[:sex].present? && !params[:camera_type].present? && !params[:interest_id].present? && !params[:distance_range].present?
      @besties = besties
      @besties.where('age <= ?', 50)
    else
      @besties = besties.where(param_clean(filter_params))
      @besties = @besties.includes(:user_interests).where(user_interests: {interest_id: params[:interest_id]})  if params[:interest_id].present?
      @besties = @besties.includes(:camera_detail).where(camera_detail: {camera_type: params[:camera_type]}) if params[:camera_type].present?
      @besties = @besties.in_range(eval(params[:distance_range]), units: :miles, origin: [@current_user.latitude, @current_user.longitude]) if params[:distance_range].present?
    end
  end

  def map_users
    @users = User.within(5, :origin => @current_user)
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