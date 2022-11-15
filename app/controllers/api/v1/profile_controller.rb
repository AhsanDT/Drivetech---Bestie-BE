class Api::V1::ProfileController < Api::V1::ApiController
  before_action :authorize_user

  def update_profile
    @profile = @current_user
    unless @profile.update(profile_params)
      render json: {
        message: 'There are error while updating profile',
        error: @profile.errors.full_messages
      }, status: :unprocessable_entity
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
  end

  def update_user_interests
    if @current_user.interests.present?
      user_interest_ids = @current_user.interests.ids - params[:interest_ids].map(&:to_i)
      user_interest_ids.each do |delete_user_interest|
        delete_user_interest = UserInterest.find_by(interest_id: delete_user_interest)
        delete_user_interest.destroy
      end
    end
    params[:interest_ids].map(&:to_i).each do |interest_id|
      @user_interests = @current_user.user_interests.find_or_create_by(interest_id: interest_id)
    end
    @current_user.reload
  end

  def update_user_talents
    if @current_user.talents.present?
      user_talent_ids = @current_user.talents.ids - params[:talent_ids].map(&:to_i)
      user_talent_ids.each do |delete_user_talent|
        delete_user_talent = UserTalent.find_by(talent_id: delete_user_talent)
        delete_user_talent.destroy
      end
    end
    params[:talent_ids].map(&:to_i).each do |talent_id|
      @user_talents = @current_user.user_talents.find_or_create_by(talent_id: talent_id)
    end
    @current_user.reload
  end

  def update_social_media
    social_media = @current_user.social_media
    if social_media.present?
      params[:social_media].each do |social|
        social_medium = @current_user.social_media.find_by(title: social[:title])
        social_medium.update(link: social[:link])
      end
      @current_user.reload
    else
      @current_user
    end
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
    params.require(:profile).permit(:email, :password, :first_name, :last_name, :location, :city, :country, :experience, :age,
                                    :sex, :rate, :phone_number, :pronoun, :latitude, :longitude, :profile_image,
                                    :id_front_image, :id_back_image, :selfie, portfolio: [], camera_detail_attributes: [ :id,
                                    :model, :camera_type, others: [] , equipment: [] ], user_interests_attributes: [:id, :interest_id],
                                    user_talents_attributes: [:id, :talent_id], social_media_attributes: [:id, :title, :link])
  end

  def social_media_params
    params.require(:social_media).permit(:title, :link, :user_id)
  end
end
