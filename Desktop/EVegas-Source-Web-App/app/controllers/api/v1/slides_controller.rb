class Api::V1::SlidesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show]

  include SlideModule

  def initialize()
    super(SLIDE_ATTRIBUTE)
  end

end