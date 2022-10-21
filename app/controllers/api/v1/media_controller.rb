class Api::V1::MediaController < Api::V1::ApiController
  before_action :authorize_user

  def update_media
    # @titles = media_params[:title].map{ |title| title.downcase }
    @media = @current_user.social_media.where(title: media_params[:title])
    @media.update(link: media_params[:link])
  end

  private

  def media_params
    params.require(:media).permit(title: [], link: [])
    
  end
end