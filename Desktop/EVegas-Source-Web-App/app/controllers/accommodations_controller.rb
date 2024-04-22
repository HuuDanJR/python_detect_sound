class AccommodationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_accommodation, only: %i[ show edit update destroy ]

  include NotificationModule
  # GET /accommodations or /accommodations.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]

    if is_blank(@search_query)
      @accommodations = Accommodation.includes(:customer => []).joins(:customer => []).order('accommodations.id desc')
    else
      @search_query = @search_query.strip
      @accommodations = Accommodation.includes(:customer => []).joins(:customer => [])
                                    .where("customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ?  OR customers.number LIKE ? ", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%")
                                    .order('accommodations.id desc')
    end
    
    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
      @accommodations = @accommodations.where("accommodations.date_pick BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    @accommodations = @accommodations.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /accommodations/1 or /accommodations/1.json
  def show
  end

  # GET /accommodations/new
  def new
    @accommodation = Accommodation.new
  end

  # GET /accommodations/1/edit
  def edit
  end

  # POST /accommodations or /accommodations.json
  def create
    @accommodation = Accommodation.new(accommodation_params)

    respond_to do |format|
      if @accommodation.save
        thread = Thread.new do
          begin
            sleep(1)
            send_notification_accomandation(@accommodation)
          rescue => e
            Rails.logger.error "Thread error: #{e.message}"
          end
        end
        
        format.html { redirect_to "/accommodations", notice: "Accommodation was successfully created." }
        format.json { render :show, status: :created, location: @accommodation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @accommodation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accommodations/1 or /accommodations/1.json
  def update
    respond_to do |format|
      if @accommodation.update(accommodation_params)
        thread = Thread.new do
          begin
            sleep(1)
            send_notification_accomandation(@accommodation)
          rescue => e
            Rails.logger.error "Thread error: #{e.message}"
          end
        end
        
        format.html { redirect_to "/accommodations", notice: "Accommodation was successfully updated." }
        format.json { render :show, status: :ok, location: @accommodation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @accommodation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accommodations/1 or /accommodations/1.json
  def destroy
    @accommodation.destroy

    respond_to do |format|
      format.html { redirect_to accommodations_url, notice: "Accommodation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accommodation
      @accommodation = Accommodation.find(params[:id])
      customer = Customer.find_by(id: @accommodation[:customer_id])
      @customer_number = customer.forename.to_s + " " + customer.middle_name.to_s + " " + customer.surname.to_s + " - " + customer.number.to_s
    end

    # Only allow a list of trusted parameters through.
    def accommodation_params
      params.require(:accommodation).permit(:time_end, :note, :date_pick, :status, :customer_id, :note_confirm, :note_cancel)
    end
end
