class NotificationsController < ApplicationController
  layout 'admin'
  require 'nokogiri'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_notification, only: %i[edit update destroy]
  skip_before_action :authorized_user, :only => [:user_by_numbers, :users_notification]
  include CommonModule
  
  include NotificationModule
  # GET /notifications or /notifications.json
  def index
    @page = params[:page]
    noti_configs = Setting.where('setting_key = ?', 'NOTIFICATION_TYPE_CONFIG').first().setting_value
    @configs = JSON.parse(noti_configs)

    @notification_type = params[:notification_type]
    @order_type = params[:order_type]
    query_order = "created_at_tmp desc"
    if is_blank(@page)
      @page = 1
    end
    @notifications = Notification.select("'send_to', source_id, title, notification_type, source_type, short_description, COUNT(*) AS total_count, SUM(CASE WHEN is_read THEN 1 ELSE 0 END) AS read_count, max(created_at) as created_at_tmp")
                        .group("source_id, title, short_description, notification_type, source_type, send_to").where('source_id != 18')
                        
    total_count = Notification.group(:source_id).where('source_id != 18')
    @search_query = params[:search]
    if !is_blank(@notification_type)
      if @notification_type.to_i == 1
        @notifications = @notifications.where("notification_type IN (1, 5, 6)")
        total_count = total_count.where("notification_type IN (1, 5, 6)")
      elsif  @notification_type.to_i == 2
        @notifications = @notifications.where("notification_type IN (2, 7, 8)")
        total_count = total_count.where("notification_type IN (2, 7, 8)")
      else
        @notifications = @notifications.where("notification_type = ?", @notification_type)
        total_count = total_count.where("notification_type = ?", @notification_type)
      end
    end

    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @notifications = @notifications.where("title LIKE ? OR short_description LIKE ? ", "%#{@search_query}%", "%#{@search_query}%")
      total_count = total_count.where("title LIKE ? OR short_description LIKE ? ", "%#{@search_query}%", "%#{@search_query}%")
    end

    if !is_blank(@order_type)
      if @order_type.to_i == 2
        query_order = "created_at_tmp asc"
      end
    end
    
    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
    else
      date_now = Time.zone.now
      @date_from = (date_now - 30.day).strftime('%Y-%m-%d')
      @date_to = date_now.strftime('%Y-%m-%d')
      date_from = (date_now - 30.day).beginning_of_day 
      date_to = date_now.end_of_day
    end
    
    @notifications = @notifications.where("created_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    total_count = total_count.where("created_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    
    total_count = total_count.count
    @notifications = @notifications.order(query_order).paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT]).group(:source_id)
    @notifications.total_entries = total_count.length
    @notifications.each do |item|
      if item.notification_type == 1 || item.notification_type == 5 || item.notification_type == 6
        message_item = Message.where(id: item.source_id).first
        if !message_item.nil?
          notification_has_login = Notification.where("status_type = 1 AND source_id = ?", message_item.id).count
          item.total_count = notification_has_login
          item.send_to = message_item.user_ids.to_i == 0 ? item.total_count : message_item.user_ids.split(',').map(&:to_i).length
        else
          item.send_to = item.total_count
        end
      else
        item.send_to = item.total_count
      end
    end

  end

  # GET /notifications/1 or /notifications/1.json
  def show
    @notification = Notification.joins(:user => []).select('notifications.*, users.email, users.name').find(params[:id])
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end

  # POST /notifications or /notifications.json
  def create
    @notification = Notification.new(notification_params)
    message = Message.new
    message[:content] = @notification[:content]
    message[:title] = params[:message_title]
    user_ids = params[:notification_ids].split(',')
    respond_to do |format|
      if message.save
        # if(user_ids.length > 0)
        #   user_ids.each do |item|
        #     notifi = Notification.new
        #     notifi.user_id = item
        #     notifi[:source_type] = "messages"
        #     notifi[:notification_type] = 1
        #     notifi[:source_id] = message.id
        #     notifi[:title] = message[:title]
        #     notifi[:status] = 1
        #     notifi[:status_type] = 1
        #     if notifi.save
        #       send_notification_to_user(item.to_i, notifi[:title], "messages", message.id, notifi.id, nil, "")
        #     end 
        #   end
        # end

        format.html { redirect_to notifications_url, notice: "Notification was successfully created." }
        format.json { head :no_content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1 or /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to notification_url(@notification), notice: "Notification was successfully updated." }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to notifications_url, notice: "Notification was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def users_notification
    search = params[:search]
    if is_blank(search)
      officer = User.select('users.id as user_id, customers.id as cus_id, customers.number as number, customers.forename, customers.middle_name, customers.surname').joins(:customer => []).limit(5).offset(0)
    else
      search = search.strip
      officer = User.where("customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ? OR customers.number = ?", "%#{search}%", "%#{search}%", "%#{search}%", "#{search}")
      .select('users.id as user_id, customers.id as cus_id, customers.number as number, customers.forename, customers.middle_name, customers.surname')
      .joins(:customer => []).limit(5).offset(0)
    end
    if !officer.nil?
      render json: officer
    end
  end

  def user_by_numbers
    data = JSON.parse(request.body.read)
    # puts data['is_number']
    where_query = ""
    if data['is_number'].to_i == 1
      where_query = "customers.number in (#{data['numbers']})"
    else
      puts data['is_number'].to_i 
      where_query = "users.id in (#{data['numbers']})"
    end
    officer = User.where(where_query)
    .select('users.id as user_id, customers.id as cus_id, customers.number as number, customers.forename, customers.middle_name, customers.surname')
    .joins(:customer => [])
    if !officer.nil?
      render json: officer
    end
  end

  def export
    search_query = params[:search]
    date_from = params[:date_from]
    date_to = params[:date_to]
    notification_type = params[:notification_type]    
    order_type = params[:order_type]
    query_order = "created_at_tmp desc"
    
    notifications = Notification.select("'send_to', source_id, title, notification_type, source_type, short_description, COUNT(*) AS total_count, SUM(CASE WHEN is_read THEN 1 ELSE 0 END) AS read_count, max(created_at) as created_at_tmp")
      .group("source_id, title, short_description, notification_type, source_type, send_to").where('source_id != 18')
    if !is_blank(notification_type)
      if notification_type.to_i == 1
        notifications = notifications.where("notification_type IN (1, 5, 6)")
      elsif notification_type.to_i == 2
        notifications = notifications.where("notification_type IN (2, 7, 8)")
      else
        notifications = notifications.where("notification_type = ?", notification_type)
      end
    end

    if !is_blank(search_query)
      search_query = search_query.strip
      notifications = notifications.where("title LIKE ? OR short_description LIKE ? ", "%#{@search_query}%", "%#{@search_query}%")
    end
    
    if !is_blank(date_from) && !is_blank(date_to)
      date_from = DateTime.parse(date_from)
      date_to = DateTime.parse(date_to).change({ hour: 23, min: 59, sec: 59 })
      notifications = notifications.where("notifications.created_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    if !is_blank(order_type)
      if order_type.to_i == 2
        query_order = "created_at_tmp asc"
      end
    end
    notifications = notifications.order(query_order)

    notifications.each do |item|
      if (item.notification_type == 1 || item.notification_type == 5 || item.notification_type == 6) && item.source_id != 18
        message_item = Message.where(id: item.source_id).first
        user_not_send = []
        if !message_item.nil?
          item.send_to = message_item.user_ids == 0 ? item.total_count : message_item.user_ids.split(',').map(&:to_i).length
        else
          item.send_to = item.total_count
        end
      else
        item.send_to = item.total_count
      end
    end

    send_file_list(notifications)
  end

  def export_notification
    notifications = Notification.joins(:user => []).select('notifications.*, users.email, users.name').where('source_id = ? AND source_type = ?', params[:source_id].to_i, params[:source_type].to_s)
    if notifications.length > 0
      send_file_list_detail(notifications)
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.require(:notification).permit(:content)
    end

    def send_file_list(lists)
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
      center_style = styles.add_style alignment: { horizontal: :center }
      sheet.add_row ["No.",
                    "Notification Name",
                     "Title",
                     "Short Description",
                     "Content",
                     "Source",
                     "Customer Number",
                     "Send Time",
                     "Login",
                     "Time Read"], style: header_style
      stt = 0

      lists.each do |item|
        data_report = notification_source(item, sheet, stt, wrap_text_style, center_style)
        sheet = data_report[:sheet]
        stt = data_report[:stt]
      end

      sheet.column_info[0].width = 5
      sheet.column_info[1].width = 15
      sheet.column_info[2].width = 30
      sheet.column_info[3].width = 40
      sheet.column_info[4].width = 40
      sheet.column_info[5].width = 18
      sheet.column_info[6].width = 18
      sheet.column_info[7].width = 18
      sheet.column_info[8].width = 16
      sheet.column_info[9].width = 14
      
      folder_name = "notifications"
      filename = "notifications_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

    def send_file_list_detail(lists)
      customerList = []
      customer_send = []
      notifi_name = ""
      if lists[0].source_type.to_s == "messages"
        messages =  Message.where(id:  lists[0].source_id.to_i).first
        if messages != nil
          notifi_name = messages.name
          if messages.customer_attachment.to_i != 0
            require 'open-uri'
            url = HOST_NAME.to_s + PATH_API_ATTACHMENT.to_s + messages.customer_attachment.to_s
            file = URI.open(url)
            spreadsheet = Roo::Spreadsheet.open(file, extension: :xlsx, convert: false)
      
            header = spreadsheet.sheet(0).row(1)
            (2..spreadsheet.sheet(0).last_row).map do |i|
              row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
              customer_send.push(FileCustomerImport.new(row["number"], row["title"], row["name"], row["amount"], row["amount2"], row["date_month_year"], row["time"], row["host_phone"]))
              customerList.push(FileCustomerImport.new(row["number"], row["title"], row["name"], row["amount"], row["amount2"], row["date_month_year"], row["time"], row["host_phone"]))
            end
            file.close
          else
            if messages.user_ids.to_i == 0
              customer_send = []
            else
              user_ids = messages.user_ids.split(',').map(&:to_i)
              customer_send_list = User.select('users.email as number, users.name as name').joins(:customer => []).where(users: { id: user_ids })
              customer_send_list.each do |item|
                customer_send.push(FileCustomerImport.new(item.number, nil, item.name, nil, nil, nil, nil, nil))
              end
            end
          end
        end
      end 
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
                     "Notification Name",
                     "Title",
                     "Short Description",
                     "Content",
                     "Number/Email",
                     "Forename",
                     "Send Time",
                     "Login",
                     "Time Read"], style: header_style
      stt = 0
      customer_sent = []
      title = ""
      short_description = ""
      time_send = ""
      text_data = ""
      lists.each do |item|
        doc = Nokogiri::HTML(item.content)
        doc.css('img').each do |img|
          img.remove if img['src'].include?('base64')
        end
        text_data = doc.text

        stt = stt + 1
        title = item.title
        short_description = item.short_description
        time_read = item.is_read ? item.updated_at.strftime("%d-%m-%Y %H:%M") : ""
        name_cfg = item.name
        email_cfg = item.email
        time_send = item.created_at.strftime("%d-%m-%Y %H:%M")
        is_send = item.status_type != -1 ? "Yes" : "No"
        customerList.each do |excel_cfg|
          if excel_cfg.number_cfg.to_s == item.email.to_s
            name_cfg = excel_cfg.name_cfg.to_s
            email_cfg = excel_cfg.number_cfg.to_s
            break
          end
        end
        customer_sent.push(item.email)

        sheet.add_row [stt.to_s,
                       notifi_name,
                       item.title,
                       item.short_description,
                       text_data,
                       email_cfg,
                       name_cfg,
                       time_send,
                       is_send,
                       time_read], types: [:string,:string,:string,:string,:string,:string,:string,:string,:string,:string], style: [nil,wrap_text_style , wrap_text_style, wrap_text_style, wrap_text_style]
      end

      customer_send.each do |item|
        unless customer_sent.any? {|number_item| number_item.to_s == item.number_cfg.to_s }
          text_data = ""
          if lists[0].source_type.to_s == "messages"
            messages =  Message.where(id:  lists[0].source_id.to_i).first
            name_cfg = ""
            title_cfg = ""
            amount_cfg = ""
            amount_cfg_2 = ""
            date_month_year_cfg = ""
            time_cfg = ""
            host_phone_cfg = ""
            customerList.each do |excel_cfg|
              if excel_cfg.number_cfg.to_s == item.number_cfg.to_s
                name_cfg = excel_cfg.name_cfg.to_s
                title_cfg = excel_cfg.title_cfg.to_s
                amount_cfg = excel_cfg.amount_cfg.to_s
                amount_cfg_2 = excel_cfg.amount_cfg_2.to_s
                date_month_year_cfg = excel_cfg.date_month_year_cfg.to_s
                time_cfg = excel_cfg.time_cfg.to_s
                host_phone_cfg = excel_cfg.host_phone_cfg.to_s
              end
            end
            text_data = replace_title_and_name_customer(messages.content, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
            doc_2 = Nokogiri::HTML(text_data)
            doc_2.css('img').each do |img|
              img.remove if img['src'].include?('base64')
            end
            text_data = doc_2.text
          end
          stt = stt + 1
          sheet.add_row [stt.to_s,
            notifi_name,
            title,
            short_description,
            text_data,
            item.number_cfg,
            item.name_cfg.to_s,
            time_send,
            "No",
            ""], types: [:string,:string,:string,:string,:string,:string,:string,:string,:string,:string], style: [nil, wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style]
        end
      end
      sheet.column_info[0].width = 5
      sheet.column_info[1].width = 15
      sheet.column_info[2].width = 30
      sheet.column_info[3].width = 40
      sheet.column_info[4].width = 40
      sheet.column_info[5].width = 18
      sheet.column_info[6].width = 18
      sheet.column_info[7].width = 18
      sheet.column_info[8].width = 16
      sheet.column_info[9].width = 12

  
      folder_name = "notifications"
      filename = "notifications_list_detail_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

    def notification_source(item_data, sheet, stt, wrap_text_style, center_style)
      customerList = []
      customer_send = []
      notifi_name = ""
      if item_data.source_type.to_s == "messages"
        messages =  Message.where(id:  item_data.source_id.to_i).first
        if messages != nil
          notifi_name = messages.name
          if messages.customer_attachment.to_i != 0
            require 'open-uri'
            url = HOST_NAME.to_s + PATH_API_ATTACHMENT.to_s + messages.customer_attachment.to_s
            file = URI.open(url)
            spreadsheet = Roo::Spreadsheet.open(file, extension: :xlsx, convert: false)
      
            header = spreadsheet.sheet(0).row(1)
            (2..spreadsheet.sheet(0).last_row).map do |i|
              row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
              customer_send.push(FileCustomerImport.new(row["number"], row["title"], row["name"], row["amount"], row["amount2"], row["date_month_year"], row["time"], row["host_phone"]))
              customerList.push(FileCustomerImport.new(row["number"], row["title"], row["name"], row["amount"], row["amount2"], row["date_month_year"], row["time"], row["host_phone"]))
            end
            file.close
          else
            if messages.user_ids.to_i == 0
              customer_send = []
            else
              user_ids = messages.user_ids.split(',').map(&:to_i)
              customer_send_list = User.select('users.email as number, users.name as name').joins(:customer => []).where(users: { id: user_ids })
              customer_send_list.each do |item|
                customer_send.push(FileCustomerImport.new(item.number, nil, item.name, nil, nil, nil, nil, nil))
              end
            end
          end
        end
      end
      lists = Notification.joins(:user => []).select('notifications.*, users.email, users.name').where('source_id = ? AND source_type = ?', item_data.source_id.to_i, item_data.source_type.to_s)
      customer_sent = []
      title = ""
      short_description = ""
      time_send = ""
      text_data = ""
      lists.each do |item|
        stt = stt + 1
        time_read = item.is_read ? item.updated_at.strftime("%d-%m-%Y %H:%M") : ""
        name_cfg = item.name
        email_cfg = item.email
        time_send = item.created_at.strftime("%d-%m-%Y %H:%M")
        is_send = item.status_type != -1 ? "Yes" : "No"
        doc = Nokogiri::HTML(item.content)
        doc.css('img').each do |img|
          img.remove if img['src'].include?('base64')
        end
        text_data = doc.text

        customerList.each do |excel_cfg|
          if excel_cfg.number_cfg.to_s == item.email.to_s
            name_cfg = excel_cfg.name_cfg.to_s
            email_cfg = excel_cfg.number_cfg.to_s
            break
          end
        end
        customer_sent.push(item.email)

        sheet.add_row [stt.to_s,
                      notifi_name,
                       item_data.title,
                       item_data.short_description,
                       text_data,
                       item_data.source_type,
                       email_cfg,
                       time_send,
                       is_send,
                       time_read], types: [:string,:string,:string,:string,:string,:string,:string,:string,:string,:string], style: [nil, wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style, nil, nil, center_style, center_style, center_style]
      end

      customer_send.each do |item|
        text_data = ""
        unless customer_sent.any? {|number_item| number_item.to_s == item.number_cfg.to_s }
          text_data = ""
          if lists[0].source_type.to_s == "messages"
            messages =  Message.where(id:  lists[0].source_id.to_i).first
            name_cfg = ""
            title_cfg = ""
            amount_cfg = ""
            amount_cfg_2 = ""
            date_month_year_cfg = ""
            time_cfg = ""
            host_phone_cfg = ""
            customerList.each do |excel_cfg|
              if excel_cfg.number_cfg.to_s == item.number_cfg.to_s
                name_cfg = excel_cfg.name_cfg.to_s
                title_cfg = excel_cfg.title_cfg.to_s
                amount_cfg = excel_cfg.amount_cfg.to_s
                amount_cfg_2 = excel_cfg.amount_cfg_2.to_s
                date_month_year_cfg = excel_cfg.date_month_year_cfg.to_s
                time_cfg = excel_cfg.time_cfg.to_s
                host_phone_cfg = excel_cfg.host_phone_cfg.to_s
              end
            end
            text_data = replace_title_and_name_customer(messages.content, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
            doc_2 = Nokogiri::HTML(text_data)
            doc_2.css('img').each do |img|
              img.remove if img['src'].include?('base64')
            end
            text_data = doc_2.text
          end

          stt = stt + 1
          sheet.add_row [stt.to_s,
                        notifi_name,
                        item_data.title,
                        item_data.short_description,
                        text_data,
                        item_data.source_type,
                        item.number_cfg,
                        time_send,
                        "No",
                        ""], types: [:string,:string,:string,:string,:string,:string,:string,:string,:string,:string], style: [nil, wrap_text_style, wrap_text_style, wrap_text_style, wrap_text_style, nil, nil, center_style, center_style, center_style]
        end
      end

      return { sheet: sheet, stt: stt }
    end
end
