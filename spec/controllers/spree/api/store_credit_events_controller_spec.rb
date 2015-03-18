require 'spec_helper'

describe Spree::Api::StoreCreditEventsController do
  render_views

  before do
    stub_authentication!
  end

  describe "GET mine" do

    subject { spree_get :mine, { format: :json } }

    context "the current api user is not persisted" do
      let(:current_api_user) { Spree.user_class.new }

      before { subject }

      it "returns a 401" do
        response.status.should eq 401
      end
    end

    context "the current api user is authenticated" do
      let(:current_api_user) { create(:user) }

      context "the user doesn't have store credit" do
        before { subject }

        it "should set the events variable to empty list" do
          assigns(:store_credit_events).should eq []
        end

        it "returns a 200" do
          subject.status.should eq 200
        end
      end

      context "the user has store credit" do
        let!(:store_credit)     { create(:store_credit, user: current_api_user) }

        before { subject }

        it "should contain one store credit event" do
          assigns(:store_credit_events).size.should eq 1
        end

        it "should contain the store credit allocation event" do
          assigns(:store_credit_events).first.should eq store_credit.store_credit_events.first
        end

        it "returns a 200" do
          subject.status.should eq 200
        end
      end
    end
  end
end
