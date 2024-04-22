class Api::V1::TermServicesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include TermServiceModule

  def initialize()
    super(TERM_SERVICE_ATTRIBUTE)
  end

end