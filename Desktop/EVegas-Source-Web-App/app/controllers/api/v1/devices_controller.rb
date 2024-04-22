class Api::V1::DevicesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update, :destroy]
  before_action :check_request_body, only: [:destroy]

  include DeviceModule
  include NotificationModule

  def initialize()
    super(DEVICE_ATTRIBUTE)
  end

  def create
    # Check params require, params option, value params
    # Need override function "check_params_create_or_update" in concrete class
    result = check_params_create_or_update(@request_body)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    # Need override function "create_object" in concrete class
    result = create_object(self.class_attribute.clazz, self.class_attribute.object_key, self.class_attribute.create_params)
    if result.result == true
      #send notification first login
      send_notification_first_login()
      render_success_json(SuccessData.new(result.status, result.data), self.class_attribute.create_except_params)
    else
      render_error_json(ErrorData.new(result.status, result.exception))
    end
  end

  def destroy
    result = check_params_destroy(@request_body)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = destroy_devices_with_token(@devices)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

end