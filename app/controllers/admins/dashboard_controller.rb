class Admins::DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index
    @users = User.paginate(page: params[:page], per_page: 4).order('created_at desc')
    @male = User.count_male_user
    @female = User.count_female_user
    @gold_subscriptions = Package.joins(:subscriptions).where(name: "Gold Package").count
    @silver_subscriptions = Package.joins(:subscriptions).where(name: "Silver Package").count
    @bronze_subscriptions = Package.joins(:subscriptions).where(name: "Bronze Package").count
  end
end
