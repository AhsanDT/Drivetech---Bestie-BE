class Admins::SubAdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:search].present?
      @sub_admins = Admin.where('email ILIKE :search OR first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search OR location ILIKE :search OR username ILIKE :search', search: "%#{params[:search]}%").paginate(page: params[:page])
    elsif params[:key] == "location"
      @sub_admins = Admin.ordered_by_country.paginate(page: params[:page])
    else
      @sub_admins = Admin.paginate(page: params[:page])
    end
  end

  def update
    @admin = Admin.find_by_id(params[:id])
    if @admin.status == 'active'
      @admin.update(status: 'inactive')
    else
       @admin.update(status: 'active')
    end
    puts @admin.status
    @admin.status
  end

  def export_to_csv
    @sub_admins = Admin.all
    respond_to do |format|
      format.csv { send_data @sub_admins.to_csv, filename: "sub-admins.csv" }
    end
  end
end
