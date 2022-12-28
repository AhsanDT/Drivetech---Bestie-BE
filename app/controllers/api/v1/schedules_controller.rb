class Api::V1::SchedulesController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_bestie, only: [:bestie_schedule]

  def create
    @schedule = Schedule.create(month: params[:month], start_time: params[:start_time], end_time: params[:end_time], day: params[:day], user_id: @current_user.id)
    render json: { data: @schedule }
  end

  def besties_availablity
    @schedules = Schedule.joins(:user).where("(?) = Any(day)", params[:day])
    render json: { data: @schedules}
  end

  def split_time(start_time,end_time)
    _format_slot = []
    temp = { start_time: "", end_time: ""}
    start_time = start_time.to_datetime
    end_time =  end_time.to_datetime
    last_start_time = ''
    last_end_time =''
    counter = 0
    while start_time < end_time
      last_start_time  = start_time.strftime("%I:%M %p") if counter == 0
      last_end_time =  (start_time+1.hour).strftime("%I:%M %p") if counter == 0
      last_start_time = (last_start_time.to_datetime+1.hour).strftime("%I:%M %p") unless counter == 0
      last_end_time =  (last_start_time.to_datetime+1.hour).strftime("%I:%M %p") unless counter == 0
      counter += 1
      temp = { start_time: last_start_time, end_time: last_end_time}
      puts temp
      _format_slot << temp
      start_time += 1.hour
    end
    _format_slot
  end

  def bestie_schedule
    if @bestie.schedule.present?
      schedule_start_time = @bestie.schedule.start_time
      schedule_end_time = @bestie.schedule.end_time
      _format_slot = split_time(schedule_start_time,schedule_end_time)
      render json: {data: _format_slot}
    else
      render json: { message: "This bestie has no schedule" }, status: :unprocessable_entity
    end
  end

  private

  def find_bestie
    @bestie = User.find_by(id: params[:bestie_id])
  end
end