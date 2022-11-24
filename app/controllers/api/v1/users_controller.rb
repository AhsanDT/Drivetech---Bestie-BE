class Api::V1::UsersController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_nearby_users, only: [:suggested_besties, :besties_near_you]

  def suggested_besties
    @besties = User.where.not(id: @current_user.id).joins(:subscriptions).uniq
    @besties = (@besties & @nearby_users)
  end

  def besties_near_you
    @besties = User.where.missing(:subscriptions)
    @besties = (@besties & @nearby_users)
  end

  private

  def find_nearby_users
    @nearby_users = User.in_range(1..1000, :units => :miles, :origin => [@current_user.latitude, @current_user.longitude])
  end
end