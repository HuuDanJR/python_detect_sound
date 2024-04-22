class Api::V1::SettingsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:get_term_of_service, :get_staff_note, :get_app_domain, :get_forgot_password] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update]

  include SettingModule

  def initialize()
    super(SETTING_ATTRIBUTE)
  end

  def get_term_of_service
    result = get_data_term_of_service()
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_staff_note
    result = get_data_staff_note()
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_app_domain
    result = get_data_app_domain()
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_forgot_password
    result = get_data_forgot_password()
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

end