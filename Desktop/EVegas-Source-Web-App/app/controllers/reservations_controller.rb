class ReservationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_reservation, only: %i[ show edit update destroy update_status]

  include CommonModule
  include NotificationModule

  # GET /reservations or /reservations.json
  def index
    @settings = Setting.where('setting_key = ?', 'BOOKING_CONFIG').first().setting_value
    settingJson = JSON.parse(@settings)
    @bookingStatuses = settingJson['status']
    @bookingTypes = settingJson['type']
    @bookingReservations = settingJson['reservation']
    @status = params[:status]
    @booking_type = params[:booking_type]
    @reservation = params[:reservation]
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    
    @reservations = Reservation.includes(:customer => []).joins(:customer => []).order("reservations.id desc")
    
    @search_query = params[:search]
    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @reservations = @reservations.where("customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ?  OR customers.number LIKE ? ", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%")
    end
    if !is_blank(@status)
      @reservations = @reservations.where("reservations.status = ?", @status)
    end
    if !is_blank(@booking_type)
      @reservations = @reservations.where("reservations.booking_type = ?", @booking_type)
    end
    if !is_blank(@reservation)
      @reservations = @reservations.where("reservations.reservation_type = ?", @reservation)
    end

    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
      @reservations = @reservations.where("reservations.pickup_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    @reservations = @reservations.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
    @reservation[:pickup_at] = DateTime.now
    @reservation[:arrival_at] = DateTime.now
    @reservation[:drop_off_at] = DateTime.now
    @drivers = Driver.select('name, nickname, id, phone')
    @car_internal = JSON.parse(Setting.where('setting_key = ?', 'CAR_INTERNAL_CONFIG').first().setting_value)
  end

  # GET /reservations/1/edit
  def edit
    @drivers = Driver.select('name, nickname, id, phone')
    @car_internal = JSON.parse(Setting.where('setting_key = ?', 'CAR_INTERNAL_CONFIG').first().setting_value)
  end

  # POST /reservations or /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    if params[:reservation][:reservation_type].to_i == 2
      @reservation[:driver_name] = params[:driver_name_other]
      @reservation[:driver_mobile] = params[:driver_mobile_other]
      @reservation[:car_type] = params[:car_type_other]
      @reservation[:license_plate] = params[:license_plate_other]
    else
      @reservation[:driver_name] = params[:driver_name_select_val]
      @reservation[:driver_mobile] = params[:reservation][:driver_mobile]
      @reservation[:car_type] = params[:type_car_select_val]
      @reservation[:license_plate] = params[:license_plate_select_val]
    end

    respond_to do |format|
      if @reservation.save
        thread = Thread.new do
          begin
            sleep(1)
            send_notification_booking_car(@reservation)
          rescue => e
            Rails.logger.error "Thread error: #{e.message}"
          end
        end

        format.html { redirect_to "/reservations", notice: "Reservation was successfully created." }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    if params[:reservation][:reservation_type].to_i == 2
      @reservation[:driver_name] = params[:driver_name_other]
      @reservation[:driver_mobile] = params[:driver_mobile_other]
      @reservation[:car_type] = params[:car_type_other]
      @reservation[:license_plate] = params[:license_plate_other]
    else
      @reservation[:driver_name] = params[:driver_name_select_val]
      @reservation[:driver_mobile] = params[:reservation][:driver_mobile]
      @reservation[:car_type] = params[:type_car_select_val]
      @reservation[:license_plate] = params[:license_plate_select_val]
    end
    
    respond_to do |format|
      if @reservation.update(reservation_params)
        thread = Thread.new do
          begin
            sleep(1)
            send_notification_booking_car(@reservation)
          rescue => e
            Rails.logger.error "Thread error: #{e.message}"
          end
        end
        
        format.html { redirect_to "/reservations", notice: "Reservation was successfully updated." }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # EXPORT /reservations/export
  def export
    reservations = Reservation.includes(:customer => []).joins(:customer => [])
    status = params[:status]
    booking_type = params[:booking_type]
    reservation = params[:reservation]
    search_query = params[:search]
    date_from = params[:date_from]
    date_to = params[:date_to]
    if !is_blank(search_query)
      search_query = search_query.strip
      reservations = reservations.where("customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ? ", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%")
    end
    
    if !is_blank(status)
      reservations = reservations.where("reservations.status = ?", status)
    end
    if !is_blank(booking_type)
      reservations = reservations.where("reservations.booking_type = ?", booking_type)
    end
    if !is_blank(reservation)
      reservations = reservations.where("reservations.reservation_type = ?", reservation)
    end
    if !is_blank(date_from) && !is_blank(date_to)
      date_from = DateTime.parse(date_from)
      date_to = DateTime.parse(date_to).change({ hour: 23, min: 59, sec: 59 })
      reservations = reservations.where("reservations.pickup_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    send_file_list(reservations.order("pickup_at desc"))
  end

  def update_status
    reservation = Reservation.find(params[:id])
    reservation.status = params[:status].to_i

    if reservation.save
      respond_to do |format|
        format.html { redirect_to reservations_url, notice: t(:update_success) }
        format.json { head :no_content }
      end
    else
      
      respond_to do |format|
        format.html { redirect_to reservations_url, notice: t(:unprocessable_entity) }
        format.json { head :no_content }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
      customer = Customer.find_by(id: @reservation[:customer_id])
      @customer_number = customer.forename.to_s + " " + customer.middle_name.to_s + " " + customer.surname.to_s + " - " + customer.number.to_s
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:customer_id, :address, :pickup_at, :customer_note, :booking_type, :reservation_type, :arrival_at, :internal_note, :price, :distance, :drop_off_at, :status, :current_location, :note_confirm, :note_cancel, :note_finish, :confirm_by)
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
      wrap_text_style = styles.add_style alignment: { wrap_text: true }
      sheet.add_row ["No.",
                     "Number",
                     "Name",
                     "Level",
                     "Pick Up Time",
                     "Drop Off Time",
                     "Occupancy(mins)",
                     "Distance",
                     "Driver",
                     "Car",
                     "Drop Off Location",
                     "Confirm",
                     "Status"], style: header_style
      stt = 0
      reservations.each do |item|
        stt = stt + 1
        drop_time = item.drop_off_at == nil ? "" : item.drop_off_at.strftime("%d-%m-%Y %H:%M")
        pick_time = item.pickup_at == nil ? "" : item.pickup_at.strftime("%d-%m-%Y %H:%M")
        occupancy_item = item.drop_off_at != nil && item.pickup_at != nil ? ((item.drop_off_at - item.pickup_at).to_i/60) : ""
        status_location = item.status == 0 ? "Cancel" : (item.status == 1 ? "Received" : (item.status == 2 ? "Confirm" : "Finish"))
        sheet.add_row [stt,
                       item.customer.number,
                       item.customer.forename.to_s + " " + item.customer.middle_name.to_s + " " + item.customer.surname.to_s,
                       item.customer.membership_type_name,
                       pick_time,
                       drop_time,
                       occupancy_item.to_s,
                       item.distance,
                       item.driver_name + " - " + item.driver_mobile,
                       item.car_type + " - " + item.license_plate,
                       item.address,
                       item.confirm_by,
                       status_location], types: [:string,:string,:string,:string,:string,:string,:string,:string,:string,:string,:string], 
                       style: [nil, wrap_text_style , wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style]
      end
      sheet.column_info[0].width = 5
      sheet.column_info[1].width = 15
      sheet.column_info[2].width = 15
      sheet.column_info[3].width = 15
      sheet.column_info[4].width = 15
      sheet.column_info[5].width = 15
      sheet.column_info[6].width = 15
      sheet.column_info[7].width = 10
      sheet.column_info[8].width = 15
      sheet.column_info[9].width = 15
      sheet.column_info[10].width = 25

      folder_name = "reservations"
      filename = "reservations_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

    # def send_notification_booking(reservation)
    #   user_cus = Customer.where('id = ?', reservation.customer_id.to_i).first
    #   setting_message = JSON.parse(Setting.where('setting_key = ?', 'BOOKING_CONFIG').first().setting_value)
    #   if user_cus != nil
    #     status = reservation[:status]
    #     notification = Notification.new
    #     notification.user_id = user_cus[:user_id]
    #     notification.source_id = reservation[:id]
    #     notification.source_type = "reservations"
    #     notification.notification_type = 2
    #     notification.status_type = status
    #     notification.status = 1
    #     setting_message['status'].each do |item|
    #       if status == item['id']
    #         notification.title = item['message']
    #         break
    #       end
    #     end
    #     notification.title = notification.title #+ " " + reservation[:internal_note].to_s
    #     if notification.save
    #       send_notification_to_user(user_cus[:user_id], notification.content, "reservations", notification.source_id, notification.id, nil, "")
    #     end
    #   end
    # end
end
