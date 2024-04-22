class Api::V1::CustomersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:lock_account_user] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update, :get_customer_by_user_id, :get_customer_voucher, :get_customer_point, :get_customer_jackpot_history, 
                                            :get_customer_machine, :sign_out_by_user, :change_password_customer, :update_avatar, :get_customer_total_voucher, :update_language, :update_setting, :update_phone]
  before_action :check_request_body, only: [:change_password_customer, :update_language, :update_setting, :update_phone]

  include CustomerModule

  def initialize()
    super(CUSTOMER_ATTRIBUTE)
  end

  def get_customer_by_user_id
    user_id = params[:id]
    result = validate_get_customer_by_user_id(user_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end
    result = get_data_customer_by_user_id(user_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_customer_point
    result = get_data_customer_point(params[:id])
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_customer_voucher
    result = get_data_voucher_customer_from_crm_neon(params[:id])
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_customer_jackpot_history
    result = get_data_customer_jackpot_history(params[:id])
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_customer_machine
    result = get_data_customer_machine(params[:id])
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def lock_account_user
    user_id = params[:id]
    result = validate_get_customer_by_user_id(user_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = lock_customer_by_user_id(user_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def sign_out_by_user
    user_id = params[:id]

    result = sign_out_user(user_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def change_password_customer
    result = check_params_change_password(@request_body)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end
    result = change_password_user(@request_body)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def update_avatar
    customer_id = params[:id]
    attachment_id = params[:attachment_id]
    result = validate_update_avatar(customer_id, attachment_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end
    result = update_avatar_customer(customer_id, attachment_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_customer_total_voucher
    result = get_data_customer_total_voucher(params[:id])
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def update_language
    # result = check_params_change_language(@request_body)
    # if result.result == false
    #   render_error_json(ErrorData.new(result.status, result.exception))
    #   return
    # end
    result = update_language_user(current_user.id, @request_body['language'])
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def update_setting
    # result = check_params_change_setting(@request_body)
    # if result.result == false
    #   render_error_json(ErrorData.new(result.status, result.exception))
    #   return
    # end
    result = update_setting_user(current_user.id, @request_body['setting'])
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def update_phone
    result = validate_change_phone(current_user.id, @request_body)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end
    result = update_phone_user(current_user.id, @request_body['phone'])
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

end