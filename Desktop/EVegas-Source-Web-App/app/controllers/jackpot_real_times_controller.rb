class JackpotRealTimesController < ApplicationController
  before_action :set_jackpot_real_time, only: %i[ show edit update destroy ]

  # GET /jackpot_real_times or /jackpot_real_times.json
  def index
    @jackpot_real_times = JackpotRealTime.all
  end

  # GET /jackpot_real_times/1 or /jackpot_real_times/1.json
  def show
  end

  # GET /jackpot_real_times/new
  def new
    @jackpot_real_time = JackpotRealTime.new
  end

  # GET /jackpot_real_times/1/edit
  def edit
  end

  # POST /jackpot_real_times or /jackpot_real_times.json
  def create
    @jackpot_real_time = JackpotRealTime.new(jackpot_real_time_params)

    respond_to do |format|
      if @jackpot_real_time.save
        format.html { redirect_to jackpot_real_time_url(@jackpot_real_time), notice: "Jackpot real time was successfully created." }
        format.json { render :show, status: :created, location: @jackpot_real_time }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jackpot_real_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jackpot_real_times/1 or /jackpot_real_times/1.json
  def update
    respond_to do |format|
      if @jackpot_real_time.update(jackpot_real_time_params)
        format.html { redirect_to jackpot_real_time_url(@jackpot_real_time), notice: "Jackpot real time was successfully updated." }
        format.json { render :show, status: :ok, location: @jackpot_real_time }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jackpot_real_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jackpot_real_times/1 or /jackpot_real_times/1.json
  def destroy
    @jackpot_real_time.destroy

    respond_to do |format|
      format.html { redirect_to jackpot_real_times_url, notice: "Jackpot real time was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jackpot_real_time
      @jackpot_real_time = JackpotRealTime.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jackpot_real_time_params
      params.require(:jackpot_real_time).permit(:data)
    end
end
