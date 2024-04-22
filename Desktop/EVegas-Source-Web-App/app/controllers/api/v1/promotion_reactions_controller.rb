class Api::V1::PromotionReactionsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include PromotionReactionModule

  def initialize()
    super(PROMOTION_REACTIOM_ATTRIBUTE)
  end
end