class Api::V1::IntroductionsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:index, :show] # Requires access token for all actions
  before_action :authenticate_user!, only: []

  include IntroductionModule

  def initialize()
    super(INTRODUCTION_ATTRIBUTE)
  end

end