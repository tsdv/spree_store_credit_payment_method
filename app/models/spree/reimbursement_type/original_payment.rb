class Spree::ReimbursementType::OriginalPayment < Spree::ReimbursementType
  extend Spree::ReimbursementType::ReimbursementHelpers

  class << self
    def reimburse(reimbursement, return_items, simulate)
      unpaid_amount = return_items.sum(&:total).round(2, :down)
      payments = reimbursement.order.payments.completed

      refund_list, unpaid_amount = create_refunds(reimbursement, payments, unpaid_amount, simulate)
      if unpaid_amount > 0.0
        refund_list, unpaid_amount = self.create_credits(reimbursement, unpaid_amount, simulate, refund_list)
      end      
      refund_list
    end

  end
end
