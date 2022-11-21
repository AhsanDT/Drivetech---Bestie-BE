class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_user

  def suggested_besties
    @subscription_users = User.where.not(id: @current_user.id).joins(:subscriptions).uniq
    @nearby_users = User.in_range(1..1000, :units => :miles, :origin => [@current_user.latitude, @current_user.longitude])
    @subscription_users = (@subscription_users & @nearby_users)
    render json: {data: @subscription_users}
  end

  def besties_near_you
    @besties = User.where.missing(:subscriptions)
    @nearby_users = User.in_range(1..1000, :units => :miles, :origin => [@current_user.latitude, @current_user.longitude])
    @besties = (@besties & @nearby_users)
    render json: {data: @besties}
  end
end