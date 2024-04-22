class Api::V1::OrdersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include OrderModule

  def initialize()
    super(ORDER_ATTRIBUTE)
  end
end