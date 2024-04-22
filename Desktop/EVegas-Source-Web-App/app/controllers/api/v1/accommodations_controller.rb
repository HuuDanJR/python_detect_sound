class Api::V1::AccommodationsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :create]

  include AccommodationModule

  def initialize()
    super(ACCOMMDATION_ATTRIBUTE)
  end

end