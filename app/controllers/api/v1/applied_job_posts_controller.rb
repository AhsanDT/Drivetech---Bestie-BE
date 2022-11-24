class Api::V1::AppliedJobPostsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_post, only: %i[ create ]
  before_action :find_applied_post, only: %i[ destroy ]
  before_action :find_applied_posts, only: %i[ index ]

  def create
    if @post.present?
      if AppliedJobPost.find_by(user_id: @current_user.id, post_id: @post.id).present?
        render json: { message: "This job has already benn applied" }        
      else
        @applied_job_post = AppliedJobPost.create(user_id: @current_user.id, post_id: @post.id)
      end
    else
      render json: { message: "This post is not present" }
    end
  end

  def destroy
    if @applied_post.present?
      @applied_post.destroy
      render json: { message: "Applied Job Post has been deleted successfully" }
    end
  end

  def index; end

  private

  def find_post
    @post = Post.find_by(id: params[:post_id])
  end

  def find_applied_post
    @applied_post = AppliedJobPost.find_by(id: params[:id])
  end

  def find_applied_posts
    @applied_job_posts = AppliedJobPost.where(user_id: @current_user.id)
  end
end