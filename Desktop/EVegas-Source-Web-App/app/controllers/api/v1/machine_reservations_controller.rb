class Api::V1::MachineReservationsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:get_list_machine_active] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update, :get_machine_reservation_neon]

  include MachineReservationModule

  def initialize()
    super(MACHINE_RESERVATION_ATTRIBUTE)
  end

  def get_machine_reservation_neon
    result = ResultHandler.new

    result = get_data_machine_number_from_neon(params["number"])
    if !result.result
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data), nil, nil, nil)
  end

  def get_list_machine_active
      started_at = params["started_at"]
      ended_at = params["ended_at"]
      list_machine_neon = get_data_machine_from_neon()
      list_machine_has_used = list_machine_has_used(started_at, ended_at)
      if list_machine_neon.length > 0 && list_machine_has_used.length > 0
        list_machine_has_used.each do |item_used|
          list_machine_neon.each do |item|
            if item_used.machine_number.to_i == item[:number].to_i && item_used.machine_name.to_s == item[:number_name].to_s
              item[:disabled] = true
            end
          end
        end
      end
      render_success_json(SuccessData.new(200, list_machine_neon), nil, nil, nil)
  end

end