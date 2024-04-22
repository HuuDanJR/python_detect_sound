class Api::V1::OfficerCustomersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include OfficerCustomerModule

  def initialize()
    super(OFFICER_CUSTOMER_ATTRIBUTE)
  end

end