class Api::V1::ProfileController < Api::V1::ApiController
  before_action :authorize_user

  def update_profile
    @profile = @current_user   
    social_media_links  = eval(profile_params[:social_media_attributes]) if profile_params[:social_media_attributes].present?
    if @profile.update(profile_params.except(:social_media_attributes))
      social_media_links&.each do |single_social_media_item|
        _social_media_plateform =  @profile.social_media.find_by(title:single_social_media_item[:title])
         _social_media_plateform.update(link:single_social_media_item[:link]) if _social_media_plateform.present?
         unless _social_media_plateform.present?
          create_social_medium_account_if_not_present(single_social_media_item[:title],single_social_media_item[:link])
         end
      end
      @profile   
    else
      render json: { message: 'There are error while updating profile', error: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_social_medium_account_if_not_present(title,link)
    if title.present? && link.present?
      @current_user.social_media.create(title: title,link: link)
    end
  end

  def switch_user
    if params[:profile_type] == "user"
      if @current_user.profile_type == "bestie"
        @current_user.update(profile_type: "user")
      else
        render json: { message: "User type is already end user" }
      end
    elsif params[:profile_type] == "bestie"
      if @current_user.profile_type == "user"
        if @current_user.camera_detail.present? && @current_user.user_talents.present? && @current_user.social_media.present? && @current_user.portfolio.present? && @current_user.rate.present?
          @current_user.update(profile_type: "bestie")
        else
          @current_user.update(profile_type: "bestie", profile_completed: "false")
        end
      else
        render json: { message: "User type is already bestie" }
      end
    end
    if @current_user.reviews.present?
      @review_rating = 0
      @current_user.reviews.each do |review|
        @review_rating  += review.rating
      end
      @review_average_rating = @review_rating / @current_user.reviews.count
    end
  end

  def update_user_interests
    return render json: {error: "Please provide any interest ids"},status: :unprocessable_entity unless params[:interest_ids].present?
    @current_user.user_interests.destroy_all
    params[:interest_ids].each do |single_id|
      @current_user.user_interests.create(interest_id: single_id.to_i) if Interest.find_by(id: single_id).present?
    end
  end

  def update_user_talents
    return render json: {error: "Please provide any interest ids"},status: :unprocessable_entity unless params[:talent_ids].present?
    @current_user.user_talents.destroy_all
    params[:talent_ids].each do |single_id|
      @current_user.user_talents.create(talent_id: single_id.to_i) if Talent.find_by(id: single_id).present?
    end
  end

  def update_social_media
    return render json: {error: "Please provide social media parameters"},status: :unprocessable_entity unless params[:social_media].present?
    social_media = eval(params[:social_media])
    social_media&.each do |social|
      social_medium = @current_user.social_media.find_by(title: social[:title])
      social_medium.update(link: social[:link]) if social_medium.present?
      unless social_medium.present?
        create_social_medium_account_if_not_present(social[:title],social[:link])
      end
    end
    @current_user
  end

  def update_portfolio
    portfolios = @current_user.portfolio
    if portfolios.present?
      portfolios.destroy_all
      params[:profile][:portfolio].each do |image|
        if image.class == String
          upload_image_to_cloundinary(image)
        else
          @current_user.portfolio.attach(image)
        end
      end
      @current_user.reload
    end
    @current_user
  end

  def upload_image_to_cloundinary(image)
    begin
      image_arr = image.split(".")
      require "down"
      tempfile = Down.download(image)
      name = image_arr[2]
      type  = image_arr.last
      @current_user.portfolio.attach(io: tempfile, filename: name, content_type: type)
    rescue => e
      render json: { error: e.message }, status: 404
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:email, :password, :first_name, :last_name, :location, :city, :country, :experience, :age, :profile_completed,
                                    :sex, :rate, :phone_number, :pronoun, :latitude, :longitude, :profile_image, :social_media_attributes,
                                    :id_front_image, :id_back_image, :selfie, portfolio: [], camera_detail_attributes: [ :id,
                                    :model, :camera_type, others: [] , equipment: [] ], user_interests_attributes: [:id, :interest_id],
                                    user_talents_attributes: [:id, :talent_id])
  end

  def social_media_params
    params.require(:social_media).permit(:title, :link, :user_id)
  end
end
