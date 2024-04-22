class Api::V1::ProductsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:index] # Requires access token for all actions
  before_action :authenticate_user!, only: [:show, :create, :update]

  include ProductModule

  def initialize()
    super(PRODUCT_ATTRIBUTE)
  end

end