# NOTE: Remove for 3-1-stable

Spree::ReimbursementType::ReimbursementHelpers.module_eval do
  def create_creditable(reimbursement, unpaid_amount)
    category = Spree::StoreCreditCategory.default_reimbursement_category(category_options(reimbursement))
    Spree::StoreCredit.new(store_credit_params(category, reimbursement, unpaid_amount))
  end

  def store_credit_params(category, reimbursement, unpaid_amount)
    {
      user: reimbursement.order.user,
      amount: unpaid_amount,
      category: category,
      created_by: Spree::StoreCredit.default_created_by,
      memo: "Refund for uncreditable payments on order #{reimbursement.order.number}",
      currency: reimbursement.order.currency
    }
  end

  # overwrite if you need options for the default reimbursement category
  def category_options(reimbursement)
    {}
  end
end
