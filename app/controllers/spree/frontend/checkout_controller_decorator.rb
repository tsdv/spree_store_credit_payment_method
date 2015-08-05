# NOTE: Remove for 3-1-stable

module SpreeStoreCredits::CheckoutControllerDecorator
  def self.prepended(base)
    base.before_action :add_store_credit_payments, only: :update
    base.prepend(InstanceMethods)
  end

  module InstanceMethods

    private

    def add_store_credit_payments
      if params.has_key?(:apply_store_credit)
        @order.add_store_credit_payments

        # Remove other payment method parameters.
        params[:order].delete(:payments_attributes)
        params.delete(:payment_source)

        # Return to the Payments page if additional payment is needed.
        if @order.payments.valid.sum(:amount) < @order.total
          redirect_to checkout_state_path(@order.state) and return
        end
      end
    end

  end
end

Spree::CheckoutController.prepend SpreeStoreCredits::CheckoutControllerDecorator
