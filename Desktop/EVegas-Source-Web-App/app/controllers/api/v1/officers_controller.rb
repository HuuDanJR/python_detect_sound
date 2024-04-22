class Api::V1::OfficersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update, :offline]

  include OfficerModule

  def initialize()
    super(OFFICER_ATTRIBUTE)
  end

  def offline
    result = validate_get_officer_by_user_id(current_user.id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end
    result = update_offline(current_user.id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end
end