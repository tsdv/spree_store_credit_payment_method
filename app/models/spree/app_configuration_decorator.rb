# NOTE: Remove for 3-1-stable

module SpreeStoreCredits::AppConfigurationDecorator
  def self.included(base)
    # Store credits configurations
    base.preference :non_expiring_credit_types, :array, default: []
    base.preference :credit_to_new_allocation, :boolean, default: false
  end
end

Spree::AppConfiguration.include SpreeStoreCredits::AppConfigurationDecorator
