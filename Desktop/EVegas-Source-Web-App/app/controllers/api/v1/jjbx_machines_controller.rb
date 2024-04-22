class Api::V1::JjbxMachinesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:create] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index]

  include JjbxMachineModule

  def initialize()
    super(JJBXMACHINE_ATTRIBUTE)
  end

end