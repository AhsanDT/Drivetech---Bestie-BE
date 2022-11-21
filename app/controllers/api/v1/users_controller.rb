class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_user

  def suggested_besties
    @subscription_users = User.where.not(id: @current_user.id).joins(:subscriptions).uniq
    render json: {data: @subscription_users}
  end

  def besties_near_you
    @besties = User.where.missing(:subscriptions)
    @nearby_users = User.within(1,:units => :kms,:origin => [@current_user.latitude, @current_user.longitude])
    @besties.union(@nearby_users)
    render json: {data: @nearby_users}
  end
end