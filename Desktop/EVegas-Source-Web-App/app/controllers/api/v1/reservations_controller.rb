class Api::V1::ReservationsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include ReservationModule

  def initialize()
    super(RESERVATION_ATTRIBUTE)
  end

end