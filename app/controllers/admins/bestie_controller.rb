class Admins::BestieController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:search].present?
      @besties = User.bestie_users.custom_search(params[:search]).paginate(page: params[:page])
    else
      @besties = User.bestie_users.paginate(page: params[:page])
    end
  end

  def show
    @bestie = User.find_by_id(params[:id])
  end

  def export_to_csv
    @besties = User.bestie_users
    respond_to do |format|
      format.csv { send_data @besties.to_csv, filename: "bestie.csv" }
    end
  end
end
