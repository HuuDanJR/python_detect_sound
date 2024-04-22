class Api::V1::OfferReactionsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include OfferReactionModule

  def initialize()
    super(OFFER_REACTIOM_ATTRIBUTE)
  end
end