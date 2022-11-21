class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_user

  def suggested_besties
    @besties = User.where.not(id: @current_user.id).joins(:subscriptions).uniq
    @nearby_users = User.in_range(1..1000, :units => :miles, :origin => [@current_user.latitude, @current_user.longitude])
    @besties = (@besties & @nearby_users)
  end

  def besties_near_you
    @besties = User.where.missing(:subscriptions)
    @nearby_users = User.in_range(1..1000, :units => :miles, :origin => [@current_user.latitude, @current_user.longitude])
    @besties = (@besties & @nearby_users)
  end
end