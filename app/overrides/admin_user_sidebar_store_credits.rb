Deface::Override.new(
  virtual_path: "spree/admin/users/_sidebar",
  name: "admin_user_sidebar_store_credits",
  insert_bottom: "[data-hook='admin_user_tab_options']",
  partial: "spree/admin/users/store_credits_sidebar",
)

Deface::Override.new(
  virtual_path: "spree/admin/users/_sidebar",
  name: "admin_user_sidebar_store_credit_balance",
  insert_bottom: "dl#user-lifetime-stats",
  partial: "spree/admin/users/store_credit_balance_sidebar",
)
