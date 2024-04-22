class Api::V1::MessagesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:show]

  include MessageModule

  def initialize()
    super(MESSAGE_ATTRIBUTE)
  end
end