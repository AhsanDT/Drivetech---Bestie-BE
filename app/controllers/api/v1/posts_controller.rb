class Api::V1::PostsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_post, only: %i[ update destroy show ]
  before_action :find_posts, only: %i[ index ]
  require 'time' 

  def create
    @post = @current_user.posts.create(post_params)
    render json: { data: @post }
  end

  def update
    if @post.present?
      @post.update(post_params)
    else
      render json: { message: "Post is not present" }
    end
  end

  def destroy
    if @post.present?
      @post.destroy
      render json: { message: "Post has been deleted" }
    else
      render json: { message: "Post is not present" }
    end
  end

  def index; end

  def show; end

  def all_posts
    @posts = Post.all
  end

  def time_slots
    array = @current_user.posts.where("(?) = Any(CAST(start_time as Date[]))",[params[:date_time].to_datetime.strftime("%a,%d %b %Y")]).pluck(:start_time).flatten.compact
    array =  array.reject(&:blank?).map{ |item| item.to_datetime.strftime("%H")+":00 "+item.to_datetime.strftime("%p") }
    _format_slot = []
    temp = { start_time: "", end_time: "", already_booked: false, date: params[:date_time]}
    hour_step = (1.to_f/24)
    date_time = params["date_time"].to_datetime
    date_time_limit = params["date_time"].to_datetime + 24.hours
    last_selected  = ''
    date_time.step(date_time_limit,hour_step).each_with_index do |interval,index|
      if index == 1
        temp[:end_time] = Time.at(interval).strftime("%I:%M %p")
        temp[:already_booked] = temp[:start_time].in?(array) ? true : false
        _format_slot << temp
        temp = { start_time: "", end_time: "", already_booked: false, date: params[:date_time]}
      elsif index == 0
        temp[:start_time] = Time.at(interval).strftime("%I:%M %p") 
      else
        temp_start_time = _format_slot[index-2][:end_time]
        temp_end_time =  (Time.at(temp_start_time.to_time)+1.hour).strftime("%I:%M %p")
        temp[:already_booked] = true if  temp[:start_time].in?(array) == true
        last_selected = temp_end_time if temp[:already_booked] == true
        temp = { start_time: temp_start_time, end_time: temp_end_time, already_booked: false, date: params[:date_time]}
        _format_slot << temp
      end
    end

    render json: {data: _format_slot}
  end

  private

  def post_params
    params.permit(:id, :title, :rate, :location, :description, :user_id, start_time: [], end_time: [], camera_type: [])
  end

  def find_post
    @post = Post.find_by(id: params[:id])
  end

  def find_posts
    @posts = @current_user.posts
  end
end