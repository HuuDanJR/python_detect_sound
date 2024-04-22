class Api::V1::PromotionSubscribersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include PromotionSubscriberModule

  def initialize()
    super(PROMOTION_SUBSCRIBER_ATTRIBUTE)
  end
end