class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:search].present?
      @end_users = user.custom_search(params[:search])
    elsif params[:key] == "sex"
      @end_users = user.ordered_by_sex
    elsif params[:key] == "age"
      @end_users = user.ordered_by_age
    elsif params[:key] == "country"
      @end_users = user.ordered_by_country
    else
      @end_users = user
    end

    @end_users = @end_users.paginate(page: params[:page])
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def export_to_csv
    @end_users = user
    respond_to do |format|
      format.csv { send_data @end_users.to_csv, filename: "users.csv" }
    end
  end

  private

  def user
    User.end_users
  end
end
