require 'spec_helper'

describe "Order" do
  describe "#create_gift_cards" do
    let(:order) { create(:order_with_line_items) }
    let(:line_item) { order.line_items.first }
    subject { order.create_gift_cards }

    context "the line item is a gift card" do
      before do
        line_item.stub(:gift_card?).and_return(true)
        line_item.stub(:quantity).and_return(3)
      end

      it 'creates a gift card for each gift card in the line item' do
        expect { subject }.to change { Spree::VirtualGiftCard.count }.by(line_item.quantity)
      end

      it 'sets the purchaser, amount, and currency' do
        Spree::VirtualGiftCard.should_receive(:create!).exactly(3).times.with(amount: line_item.price, currency: line_item.currency, purchaser: order.user, line_item: line_item)
        subject
      end

      context "create_gift_cards runs twice" do
        it 'does not create duplicate gift cards' do
          order.create_gift_cards
          expect { subject }.to_not change { Spree::VirtualGiftCard.count }
        end
      end
    end

    context "the line item is not a gift card" do
      before { line_item.stub(:gift_card?).and_return(false) }

      it 'does not create a gift card' do
        Spree::VirtualGiftCard.should_not_receive(:create!)
        subject
      end
    end
  end

  describe "#finalize!" do
    context "the order contains gift cards and transitions to complete" do
      let(:order) { create(:order_with_line_items, state: 'complete') }

      subject { order.finalize! }

      it "calls #create_gift_cards" do
        pending "Disabled on purpose."
        order.should_receive(:create_gift_cards)
        subject
      end
    end
  end

  describe "transition to complete" do
    let(:order) { create(:order_with_line_items, state: 'confirm') }
    let!(:payment) { create(:payment, order: order, state: 'pending') }
    subject { order.next! }

    it "calls #send_gift_card_emails" do
      pending "Disabled on purpose."
      order.should_receive(:send_gift_card_emails)
      subject
    end

  end

  describe "#send_gift_card_emails" do

    subject { order.send_gift_card_emails }

    context "the order has gift cards" do
      let(:gift_card) { create(:virtual_gift_card) }
      let(:line_item) { gift_card.line_item }
      let(:gift_card_2) { create(:virtual_gift_card, line_item: line_item) }
      let(:order) { gift_card.line_item.order }

      it "should call GiftCardMailer#send" do
        expect(Spree::GiftCardMailer).to receive(:gift_card_email).with(gift_card).and_return(double(deliver: true))
        expect(Spree::GiftCardMailer).to receive(:gift_card_email).with(gift_card_2).and_return(double(deliver: true))
        subject
      end
    end

    context "no gift cards" do
      let(:order) { create(:order_with_line_items) }

      it "should not call GiftCardMailer#send" do
        expect(Spree::GiftCardMailer).to_not receive(:gift_card_email)
        subject
      end
    end
  end

end
