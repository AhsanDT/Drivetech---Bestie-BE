class Admin::SubAdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @sub_admin = Admin.all
  end
end
