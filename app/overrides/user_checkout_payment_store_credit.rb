# NOTE: Remove for 3-1-stable

Deface::Override.new(
  virtual_path: 'spree/checkout/_payment',
  name: 'insert_store_credit_instructions',
  insert_before: '#payment-method-fields',
  partial: 'spree/checkout/payment/storecredit'
)
