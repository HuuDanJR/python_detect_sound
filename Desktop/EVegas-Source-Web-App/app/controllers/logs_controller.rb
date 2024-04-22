class LogsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user

  # GET /logs or /logs.json
  def index
    @mystery_jackpots = MysteryJackpot.last
    @jackpot_machines = JackpotMachine.last

    @jackpot_real_times = JackpotRealTime.last
    @jjbx_machine = JjbxMachine.last
  end

end
