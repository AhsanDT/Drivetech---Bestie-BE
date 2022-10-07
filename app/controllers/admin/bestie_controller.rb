class Admin::BestieController < ApplicationController
  before_action :authenticate_admin!

  def index
    @besties = User.bestie_users
  end

  def show
    @bestie = User.find_by_id(params[:id])
  end
end
