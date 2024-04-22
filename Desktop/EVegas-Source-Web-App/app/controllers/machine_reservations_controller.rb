class MachineReservationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_machine_reservation, only: %i[ show edit update destroy ]
  skip_before_action :authorized_user, :only => []

  include CommonModule
  include NotificationModule
  include MachineReservationModule

  # GET /machine_reservations or /machine_reservations.json
  def index
    @settings = Setting.where('setting_key = ?', 'MACHINE_BOOKING_CONFIG').first().setting_value
    settingJson = JSON.parse(@settings)
    @bookingStatuses = settingJson['status']
    @bookingTypes = settingJson['type']
    @status = params[:status]
    # @booking_type = params[:booking_type]
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    
    @machine_reservations = MachineReservation.includes(:customer => []).joins(:customer => []).order("machine_reservations.id desc")
    
    @search_query = params[:search]
    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @machine_reservations = @machine_reservations.where("customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ? OR customers.number LIKE ? ", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%")
    end
    if !is_blank(@status)
      @machine_reservations = @machine_reservations.where("machine_reservations.status = ?", @status)
    end
    # if !is_blank(@booking_type)
    #   @machine_reservations = @machine_reservations.where("machine_reservations.booking_type = ?", @booking_type)
    # end

    @date_from = params[:date_from]
    @date_to = params[:date_to]

    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = Time.zone.parse(@date_from).beginning_of_day 
      date_to = Time.zone.parse(@date_to).end_of_day
      @machine_reservations = @machine_reservations.where("machine_reservations.ended_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end
    @machine_reservations = @machine_reservations.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /machine_reservations/1 or /machine_reservations/1.json
  def show
  end

  # GET /machine_reservations/new
  def new
    @machine_reservation = MachineReservation.new
    # @machine_numbers = get_data_machine_from_neon()
    @machine_reservation[:started_at] = DateTime.now
    @machine_reservation[:ended_at] = DateTime.now
    @machine_reservation[:status] = 2
  end

  # GET /machine_reservations/1/edit
  def edit
    # @machine_numbers = get_data_machine_from_neon()
  end

  # POST /machine_reservations or /machine_reservations.json
  def create
    @machine_reservation = MachineReservation.new(machine_reservation_params)
    gametheme = Gametheme.where('game_type_id = ? AND name = ?', params[:game_type_id], params[:machine_reservation][:machine_name]).first
    if gametheme == nil
      game_theme = Gametheme.new
      game_theme.game_type_id = params[:game_type_id].to_i
      game_theme.name = params[:machine_reservation][:machine_name].to_s
      game_theme.created_at = Time.zone.now
      game_theme.updated_at = Time.zone.now
      if game_theme.save
        @machine_reservation.gametheme_id = game_theme.id
      end
    else
      @machine_reservation.gametheme_id = gametheme.id
    end

    respond_to do |format|
      if @machine_reservation.save
        thread = Thread.new do
          begin
            sleep(1)
            send_notification_machine_reservation(@machine_reservation)
          rescue => e
            Rails.logger.error "Thread error: #{e.message}"
          end
        end
        
        format.html { redirect_to "/machine_reservations", notice: "Machine reservation was successfully created." }
        format.json { render :show, status: :created, location: @machine_reservation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @machine_reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machine_reservations/1 or /machine_reservations/1.json
  def update
    gametheme = Gametheme.where('game_type_id = ? AND name = ?', params[:game_type_id], params[:machine_reservation][:machine_name]).first
    if gametheme == nil
      game_theme = Gametheme.new
      game_theme.game_type_id = params[:game_type_id].to_i
      game_theme.name = params[:machine_reservation][:machine_name].to_s
      game_theme.created_at = Time.zone.now
      game_theme.updated_at = Time.zone.now
      if game_theme.save
        @machine_reservation.gametheme_id = game_theme.id
      end
    else
      @machine_reservation.gametheme_id = gametheme.id
    end
    
    respond_to do |format|
      if @machine_reservation.update(machine_reservation_params)
        # send_notification_machine_reservation(@machine_reservation)
        
        format.html { redirect_to "/machine_reservations", notice: "Machine reservation was successfully updated." }
        format.json { render :show, status: :ok, location: @machine_reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @machine_reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /machine_reservations/1 or /machine_reservations/1.json
  def destroy
    @machine_reservation.destroy

    respond_to do |format|
      format.html { redirect_to machine_reservations_url, notice: "Machine reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # EXPORT /reservations/export
  def export
    machine_reservations = MachineReservation.includes(:customer => []).joins(:customer => [])
    status = params[:status]
    booking_type = params[:booking_type]
    search_query = params[:search]
    date_from = params[:date_from]
    date_to = params[:date_to]
    if !is_blank(search_query)
      search_query = search_query.strip
      machine_reservations = machine_reservations.where("customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ? ", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%")
    end
    puts booking_type
    if !is_blank(status)
      machine_reservations = machine_reservations.where("machine_reservations.status = ?", status)
    end
    if !is_blank(booking_type)
      machine_reservations = machine_reservations.where("machine_reservations.booking_type = ?", booking_type)
    end
    if !is_blank(date_from) && !is_blank(date_to)
      date_from = DateTime.parse(date_from)
      date_to = DateTime.parse(date_to).change({ hour: 23, min: 59, sec: 59 })
      machine_reservations = machine_reservations.where("machine_reservations.started_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    send_file_list(machine_reservations)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine_reservation
      @machine_reservation = MachineReservation.find(params[:id])
      customer = Customer.find_by(id: @machine_reservation[:customer_id])
      @customer_number = customer.forename.to_s + " " + customer.middle_name.to_s + " " + customer.surname.to_s + " - " + customer.number.to_s
    end

    # Only allow a list of trusted parameters through.
    def machine_reservation_params
      params.require(:machine_reservation).permit(:customer_id, :machine_number, :machine_name, :started_at, :ended_at, :customer_note, :booking_type, :internal_note, :status, :customer_number, :zone, :results_play, :approved_by, :updated_by)
    end

    def send_file_list(reservations)
      book = Axlsx::Package.new
      workbook = book.workbook
      sheet = workbook.add_worksheet name: "Report"
  
      styles = book.workbook.styles
      header_style = styles.add_style bg_color: "ffff00",
                                      fg_color: "00",
                                      b: true,
                                      alignment: {horizontal: :center},
                                      border: {style: :thin, color: 'F000000', :edges => [:left, :right, :top, :bottom]}
      border_style = styles.add_style :border => {:style => :thin, :color => 'F000000', :edges => [:left, :right, :top, :bottom]}
  
      sheet.add_row ["id",
                     "customer_id",
                     "customer_name",
                     "machine_number",
                     "machine_name",
                     "started_at",
                     "ended_at",
                     "customer_note",
                     "booking_type",
                     "internal_note"], style: header_style
  
      reservations.each do |item|
        language = {}
        sheet.add_row [item.id,
                       item.customer_id,
                       item.customer.forename.to_s + " " + item.customer.middle_name.to_s + " " + item.customer.surname.to_s,
                       item.machine_number,
                       item.machine_name,
                       item.started_at,
                       item.ended_at,
                       item.customer_note,
                       item.booking_type,
                       item.internal_note]
      end
  
      folder_name = "machine_reservations"
      filename = "machine_reservations_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

end
