class Api::V1::PyramidPointsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include PyramidPointModule

  def initialize()
    super(PYRAMID_POINT_ATTRIBUTE)
  end

end