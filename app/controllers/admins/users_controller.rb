class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:search].present?
      @end_users = User.end_users.custom_search(params[:search]).paginate(page: params[:page])
    else
      @end_users = User.end_users.paginate(page: params[:page])
    end
  end

  def show
    @user = User.find_by_id(params[:id])
  end
end
