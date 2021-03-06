class Spree::Admin::GiftCardsController < Spree::Admin::BaseController
  before_filter :load_gift_card, only: [:show]

  def index
  end

  def show
  end

  private

  def load_gift_card
    redemption_code = Spree::RedemptionCodeGenerator.format_redemption_code_for_lookup(params[:id])
    @gift_cards = Spree::VirtualGiftCard.where(redemption_code: redemption_code)

    if @gift_cards.empty?
      flash[:error] = Spree.t('admin.gift_cards.errors.not_found')
      redirect_to(admin_gift_cards_path)
    end
  end
end
