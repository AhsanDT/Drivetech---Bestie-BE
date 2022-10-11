class Admins::SubAdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:search].present?
      @sub_admins = Admin.custom_search(params[:search]).paginate(page: params[:page])
    else
      @sub_admins = Admin.paginate(page: params[:page])
    end
  end

  def update
    @admin = Admin.find_by_id(params[:id])
    if @admin.status == 'active'
      if @admin.update(status: 'inactive')
        flash[:alert] = 'Sub admin inactive successfully'
        redirect_to admins_sub_admins_path
      end
    else
      if @admin.update(status: 'active')
        flash[:alert] = 'Sub admin active successfully'
        redirect_to admins_sub_admins_path
      end
    end
  end
end
