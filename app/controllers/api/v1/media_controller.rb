class Api::V1::MediaController < Api::V1::ApiController
  before_action :authorize_user

  def update_media
    @titles = media_params[:title].map{ |title| title.downcase }
    @media = @current_user.social_media.where('title IN (?)',  @titles)
    
    @media.each_with_index do |media, index|
      media.update(link: media_params[:link][index])
    end
  end

  private

  def media_params
    params.require(:media).permit(link: [], title: [])
  end
end
