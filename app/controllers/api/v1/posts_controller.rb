class Api::V1::PostsController < Api::V1::ApiController
  before_action :authorize_user

  def create
    @post = @current_user.posts.create(post_params)
    render json: { data: @post }
  end

  private

  def post_params
    params.permit(:id, :title, :rate, :location, :description, :user_id, date: [], camera_type: [])
  end

end