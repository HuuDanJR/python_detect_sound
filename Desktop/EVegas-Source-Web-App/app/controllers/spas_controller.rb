class SpasController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_spa, only: %i[ show edit update destroy ]

  include NotificationModule
  # GET /spas or /spas.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @spas = Spa.includes(:customer => []).joins(:customer => []).order('spas.id desc')
    else
      @search_query = @search_query.strip
      @spas = Spa.includes(:customer => []).
      joins(:customer => []).where("customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ?  OR customers.number LIKE ? ", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%").order('spas.id desc')
    end
    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
      @spas = @spas.where("spas.date_pick BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    @spas = @spas.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /spas/1 or /spas/1.json
  def show
  end

  # GET /spas/new
  def new
    @spa = Spa.new
  end

  # GET /spas/1/edit
  def edit
  end

  # POST /spas or /spas.json
  def create
    @spa = Spa.new(spa_params)

    respond_to do |format|
      if @spa.save
        thread = Thread.new do
          begin
            sleep(1)
            send_notification_spa(@spa)
          rescue => e
            Rails.logger.error "Thread error: #{e.message}"
          end
        end
        
        format.html { redirect_to "/spas", notice: "Spa was successfully dupplicated." }
        format.json { render :show, status: :created, location: @spa }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @spa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spas/1 or /spas/1.json
  def update
    respond_to do |format|
      if @spa.update(spa_params)
        thread = Thread.new do
          begin
            sleep(1)
            send_notification_spa(@spa)
          rescue => e
            Rails.logger.error "Thread error: #{e.message}"
          end
        end
        format.html { redirect_to "/spas", notice: "Spa was successfully updated." }
        format.json { render :show, status: :ok, location: @spa }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @spa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spas/1 or /spas/1.json
  def destroy
    @spa.destroy

    respond_to do |format|
      format.html { redirect_to spas_url, notice: "Spa was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spa
      @spa = Spa.find(params[:id])
      customer = Customer.find_by(id: @spa[:customer_id])
      @customer_number = customer.forename.to_s + " " + customer.middle_name.to_s + " " + customer.surname.to_s + " - " + customer.number.to_s
    end

    # Only allow a list of trusted parameters through.
    def spa_params
      params.require(:spa).permit(:note, :date_pick, :time_pick, :status, :customer_id, :note_confirm, :note_cancel)
    end
end
