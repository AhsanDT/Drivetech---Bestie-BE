class Api::V1::ApiController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def param_clean(_params)
    _params.delete_if do |k, v|
      if v.instance_of?(ActionController::Parameters)
        param_clean(v)
      end
      v.empty?
    end
  end
end
