class OrdersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_order, only: %i[ show edit update destroy ]
  include CommonModule
  include NotificationModule
  # GET /orders or /orders.json
  def index
    @settings = Setting.where('setting_key = ?', 'ORDER_BOOKING_CONFIG').first().setting_value
    settingJson = JSON.parse(@settings)
    @bookingStatuses = settingJson['status']
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    
    @orders = Order.includes(:customer => []).joins(:customer => []).order("orders.id desc").paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])


    @search_query = params[:search]
    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @orders = @orders.where("customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ? OR customers.number = ?", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%", "#{@search_query}").paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end

    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
      @orders = @orders.where("orders.created_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S")).paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end

  end

  # GET /orders/1 or /orders/1.json
  def show
    @orders = Order.includes(:customer => []).joins(:customer => []).where("orders.id = ?", params[:id]).first
    @product_orders = OrderProduct.includes(:product => []).joins(:product => []).where("order_products.order_id = ?", params[:id])
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
    @orders = Order.includes(:customer => []).joins(:customer => []).where("orders.id = ?", params[:id]).first
    @product_orders = OrderProduct.includes(:product => []).joins(:product => []).where("order_products.order_id = ?", params[:id])
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        send_notification_order(@order)
        format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        send_notification_order(@order)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def export
    orders = Order.includes(:customer => []).joins(:customer => []).order("orders.id desc")

    customer = params[:customer]
    if !is_blank(customer)
      orders = orders.where("orders.customer_id = ?", customer)
    end

    @ate_from = params[:date_from]
    date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(date_to)
      date_from = DateTime.parse(date_from)
      date_to = DateTime.parse(date_to).change({ hour: 23, min: 59, sec: 59 })
      orders = orders.where("orders.created_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end
    send_file_list(orders)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:customer_id, :total, :status, :internal_note)
    end

    def send_file_list(orders)
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
                     "Customer",
                     "Level",
                     "Total",
                     "created_at"], style: header_style
  
      orders.each do |item|
        language = {}
        sheet.add_row [item.id,
                       item.customer.forename.to_s + " " + item.customer.middle_name.to_s + " " + item.customer.surname.to_s,
                       item.customer.membership_type_name,
                       item.total,
                       item.created_at.strftime("%d-%m-%Y at %T")]
      end
  
      folder_name = "Orders"
      filename = "Orders_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

    def send_notification_order(order)
      user_cus = User.select('users.id, users.language').joins(:customer).where('customers.id = ?', order.customer_id.to_i).first
      setting_message = JSON.parse(Setting.where('setting_key = ?', 'ORDER_BOOKING_CONFIG').first().setting_value)
      noti_title = "E-VG Caravelle"
      if setting != nil
        noti_title = setting.setting_value
      end
      if user_cus != nil
        status = order[:status]
        notification = Notification.new
        notification.user_id = user_cus[:user_id]
        notification.source_id = order[:id]
        notification.source_type = "orders"
        notification.notification_type = 4
        notification.status_type = status
        notification.status = 1
        setting_message['status'].each do |item|
          if status == item['id']
            notification.title = noti_title
            notification.title_ja = noti_title
            notification.title_kr = noti_title
            notification.title_cn = noti_title
            notification.content = item['message']
            notification.content_ja = item['message_ja']
            notification.content_kr = item['message_ko']
            notification.content_cn = item['message_zh']
            notification.short_description = item['message']
            notification.short_description_ja = item['message_ja']
            notification.short_description_kr = item['message_ko']
            notification.short_description_cn = item['message_zh']
            break
          end
        end
        if notification.save
          if user.language == 'ja'
            send_notification_to_user(user.id, notification.title_ja, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_ja)
          elsif user.language == 'ko'
            send_notification_to_user(user.id, notification.title_kr, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_kr)
          elsif user.language == 'zh'
            send_notification_to_user(user.id, notification.title_cn, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_cn)
          else
            send_notification_to_user(user.id, notification.title, notification.source_type, notification.source_id, notification.id, nil, notification.short_description)
          end
        end
      end
    end
end
