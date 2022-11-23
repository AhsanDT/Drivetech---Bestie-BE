class Api::V1::PostsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_post, only: %i[ update destroy show ]
  before_action :find_posts, only: %i[ index ]

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