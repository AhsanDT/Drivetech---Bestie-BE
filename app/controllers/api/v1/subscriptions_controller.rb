class Api::V1::SubscriptionsController < Api::V1::ApiController
  before_action :authorize_user
  before_action :find_package, only: [:create]
  before_action :find_subscription, only: [:destroy]

  def get_packages
    packages = Package.all
    render json: { message: "All packages", data: packages }
  end

  def create
    @customer = get_stripe_customer
    if @package.present?
      begin
        @stripe_subscription = StripeService.create_subscription(@customer.id, @package.price_id)
        @subscription = create_customer_subscription(@stripe_subscription)
        render json: {message: "Successfull subscription", data: @subscription}
      rescue => e
        return render json: e.message
      end
    else
      render json: { message: "This package is not present" }
    end
  end

  def destroy
    stripe_subscription = StripeService.retrieve_subscription(@subscription.subscription_id)
    if @subscription.present?
      begin
        StripeService.delete_subscription(@subscription.subscription_id)
        @subscription.destroy
        render json: { message: "Subscription has been successfully cancelled!" }
      rescue => e
        return render json: e.message
      end
    else
      render json: { message: "Subscription is not present" }
    end
  end

  def current_user_subscription
    @subscription = @current_user.subscriptions.last
    if @subscription.present?
      if @subscription.package.name == "Gold Package"
        @remaining_time = (@subscription.created_at + 7.day - Time.now) / 60
        check_positive(@remaining_time)
      elsif @subscription.package.name == "Silver Package"
        @remaining_time = (@subscription.created_at + 3.day - Time.now) / 60
        check_positive(@remaining_time)
      elsif @subscription.package.name == "Bronze Package"
        @remaining_time = (@subscription.created_at + 1.day - Time.now) / 60
        check_positive(@remaining_time)
      end
    else
      render json: {message: "No subscription found"}
    end
    @remaining_time
  end

  private

  def get_stripe_customer
    if @current_user.stripe_customer_id.present?
      begin
        customer = Stripe::Customer.retrieve(@current_user.stripe_customer_id)
      rescue => e
        return render json: {message: e}
      end
    else
      customer = StripeService.create_customer(@current_user.first_name, @current_user.email)
      @current_user.update(stripe_customer_id: customer.id) rescue nil
    end
    return customer
  end

  def find_package
    @package = Package.find_by(id: params[:package_id])
  end

  def create_customer_subscription(data)
    subscription = @current_user.subscriptions.create(package_id: @package.id, subscription_id: data.id)
  end

  def find_subscription
    @subscription = Subscription.find_by(id: params[:id])
  end

  def check_positive(remaining_time)
    if @remaining_time >= 1
      return @remaining_time
    else
      render json: {message: "No subscription found"}
    end
  end
end