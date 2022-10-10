class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @end_users = User.end_users
  end

  def show
    @user = User.find_by_id(params[:id])
  end
end
