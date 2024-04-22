class Api::V1::OfferSubscribersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include OfferSubscriberModule

  def initialize()
    super(OFFER_SUBSCRIBER_ATTRIBUTE)
  end
end