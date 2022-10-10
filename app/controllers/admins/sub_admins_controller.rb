class Admins::SubAdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @sub_admins = Admin.all
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
