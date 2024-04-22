class Api::V1::SpasController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :create]

  include SpaModule

  def initialize()
    super(SPA_ATTRIBUTE)
  end

end