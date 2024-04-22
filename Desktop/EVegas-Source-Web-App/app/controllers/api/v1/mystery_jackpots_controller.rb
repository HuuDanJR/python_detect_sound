class Api::V1::MysteryJackpotsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:create] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index]

  include MysteryJackpotModule

  def initialize()
    super(MYSTERY_JACKPOT_ATTRIBUTE)
  end

end