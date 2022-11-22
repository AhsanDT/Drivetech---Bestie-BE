class Api::V1::SchedulesController < Api::V1::ApiController
  before_action :authorize_user

  def create
    @schedule = Schedule.create(month: params[:month], start_time: params[:start_time], end_time: params[:end_time], day: params[:day], user_id: @current_user.id)
    render json: { data: @schedule }
  end

  def besties_availablity
    @schedules = Schedule.joins(:user).where("(?) = Any(day)", params[:day])
    render json: { data: @schedules}
  end
end