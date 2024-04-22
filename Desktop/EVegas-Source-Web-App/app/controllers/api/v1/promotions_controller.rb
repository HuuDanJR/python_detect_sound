class Api::V1::PromotionsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:index] # Requires access token for all actions
  before_action :authenticate_user!, only: [ :show, :create, :update]

  include PromotionModule

  def initialize()
    super(PROMOTION_ATTRIBUTE)
  end

end