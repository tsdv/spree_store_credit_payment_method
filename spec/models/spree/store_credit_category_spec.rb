require 'spec_helper'

describe Spree::StoreCreditCategory, :type => :model do
  describe "#non_expiring?" do
    subject { build(:store_credit_category, name: category_name).non_expiring? }
    
    context "non-expiring type store credit" do
      let(:category_name) { "Gift Card" }

      it "returns true" do
        expect(subject).to be true
      end
    end

    context "expiring type store credit" do
      let(:category_name) { "Expiring" }

      it "returns false" do
        expect(subject).to be false
      end
    end
  end
end
