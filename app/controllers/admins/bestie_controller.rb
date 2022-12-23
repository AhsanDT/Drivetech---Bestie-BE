class Admins::BestieController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:search].present?
      @besties = besties.where('email ILIKE :search OR cast(age as text) ILIKE :search OR first_name ILIKE :search OR last_name ILIKE :search OR phone_number ILIKE :search OR country ILIKE :search OR sex ILIKE :search', search: "%#{params[:search]}%")
    elsif params[:key] == "sex"
      @besties = besties.ordered_by_sex
    elsif params[:key] == "age"
      @besties = besties.ordered_by_age
    elsif params[:key] == "country"
      @besties = besties.ordered_by_country
    else
      @besties = besties
    end

    @besties = @besties.paginate(page: params[:page])
  end

  def show
    @bestie = User.find_by_id(params[:id])
  end

  def export_to_csv
    @besties = besties
    respond_to do |format|
      format.csv { send_data @besties.to_csv, filename: "bestie.csv" }
    end
  end

  private

  def besties
    User.bestie_users
  end
end
