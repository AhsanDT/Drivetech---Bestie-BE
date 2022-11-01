class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:search].present?
      @end_users = User.end_users.custom_search(params[:search]).paginate(page: params[:page])
    elsif params[:key] == "sex"
      @end_users = User.end_users.ordered_by_sex.paginate(page: params[:page])
    elsif params[:key] == "age"
      @end_users = User.end_users.ordered_by_age.paginate(page: params[:page])
    elsif params[:key] == "country"
      @end_users = User.end_users.ordered_by_country.paginate(page: params[:page])
    else
      @end_users = User.end_users.paginate(page: params[:page])
    end
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def export_to_csv
    @end_users = User.end_users
    respond_to do |format|
      format.csv { send_data @end_users.to_csv, filename: "end-users.csv" }
    end
  end
end
