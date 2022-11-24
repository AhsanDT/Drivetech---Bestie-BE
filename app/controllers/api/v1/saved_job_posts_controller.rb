class Api::V1::SavedJobPostsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_post, only: %i[ create ]
  before_action :find_saved_post, only: %i[ destroy ]
  before_action :find_saved_posts, only: %i[ index ]

  def create
    if @post.present?
      if SavedJobPost.find_by(user_id: @current_user.id, post_id: @post.id).present?
        render json: { message: "This job has already been applied" }        
      else
        @saved_job_post = SavedJobPost.create(user_id: @current_user.id, post_id: @post.id)
      end
    else
      render json: { message: "This post is not present" }
    end
  end

  def destroy
    if @saved_post.present?
      @saved_post.destroy
      render json: { message: "Saved Job Post has been deleted successfully" }
    else
      render json: { message: "This post is not present" }
    end
  end

  def index; end

  private

  def find_post
    @post = Post.find_by(id: params[:post_id])
  end

  def find_saved_post
    @saved_post = SavedJobPost.find_by(id: params[:id])
  end

  def find_saved_posts
    @saved_job_posts = SavedJobPost.where(user_id: @current_user.id)
  end
end