class Api::V1::StaticPageController < Api::V1::ApiController

  def static_page
    page = Page.find_by(permalink: params[:permalink])
    if page.present?
      render json: {
        data: page.title,
        body: page.content.body.to_trix_html
      }, status: :ok
    else
      render json: {
        message: 'Page not found'
      }, status: :ok
    end
  end
end
