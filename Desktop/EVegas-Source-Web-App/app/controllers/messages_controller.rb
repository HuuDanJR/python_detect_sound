class MessagesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_message, only: %i[ show edit update destroy preview copy_message update_send_all]
  skip_before_action :authorized_user, :only => [:get_customers]

  include NotificationModule
  include AttachmentModule

  # GET /messages or /messages.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @messages = Message.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @messages = Message.where("title LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
    @message.time_send = DateTime.now
    @messageTypes = JSON.parse(Setting.where('setting_key = ?', 'MESSAGE_CATEGORY_TYPE').first().setting_value)
  end

  # GET /messages/1/edit
  def edit
    @messageTypes = JSON.parse(Setting.where('setting_key = ?', 'MESSAGE_CATEGORY_TYPE').first().setting_value)
  end

  # POST /messages or /messages.json
  def create
    @messageTypes = JSON.parse(Setting.where('setting_key = ?', 'MESSAGE_CATEGORY_TYPE').first().setting_value)
    result = true
    @message = Message.new(message_params)
    user_ids = params[:user_ids]
    # user_ids = params[:user_ids].reject(&:empty?).map(&:to_i)
    @message.user_ids = user_ids
    respond_to do |format|
      attachment = get_attachment_from_request(params[:message][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @message.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end

      
      customer_attachment_file = get_attachment_from_request(params[:message][:customer_attachment_file])
      if customer_attachment_file != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(customer_attachment_file)
          if _ok
            @message.customer_attachment = customer_attachment_file.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
      @message.title = params[:message][:title].gsub(/[^[:print:]]/,'')
      @message.title_kr = params[:message][:title_kr].gsub(/[^[:print:]]/,'')
      @message.title_ja = params[:message][:title_ja].gsub(/[^[:print:]]/,'')
      @message.title_cn = params[:message][:title_cn].gsub(/[^[:print:]]/,'')
      
      @message.short_description = params[:message][:short_description].gsub(/[^[:print:]]/,'')
      @message.short_description_kr = params[:message][:short_description_kr].gsub(/[^[:print:]]/,'')
      @message.short_description_ja = params[:message][:short_description_ja].gsub(/[^[:print:]]/,'')
      @message.short_description_cn = params[:message][:short_description_cn].gsub(/[^[:print:]]/,'')
      if @message.save
        if !@message.is_draft && @message.user_ids.to_i != 0 && @message.time_send < DateTime.now
          send_notification_job(@message)
        end
        redirect_to(@message)
        return
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    @messageTypes = JSON.parse(Setting.where('setting_key = ?', 'MESSAGE_CATEGORY_TYPE').first().setting_value)
    result = true
    respond_to do |format|
      attachment = get_attachment_from_request(params[:message][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @message.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
      customer_attachment_file = get_attachment_from_request(params[:message][:customer_attachment_file])
      if customer_attachment_file != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(customer_attachment_file)
          if _ok
            @message.customer_attachment = customer_attachment_file.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
      @message.title = params[:message][:title].gsub(/[^[:print:]]/,'')
      @message.title_kr = params[:message][:title_kr].gsub(/[^[:print:]]/,'')
      @message.title_ja = params[:message][:title_ja].gsub(/[^[:print:]]/,'')
      @message.title_cn = params[:message][:title_cn].gsub(/[^[:print:]]/,'')
      
      @message.short_description = params[:message][:short_description].gsub(/[^[:print:]]/,'')
      @message.short_description_kr = params[:message][:short_description_kr].gsub(/[^[:print:]]/,'')
      @message.short_description_ja = params[:message][:short_description_ja].gsub(/[^[:print:]]/,'')
      @message.short_description_cn = params[:message][:short_description_cn].gsub(/[^[:print:]]/,'')
      user_ids = params[:user_ids]
      @message.user_ids = user_ids
      if @message.update(message_update_params)
        format.html { redirect_to messages_url, notice: "Message was successfully created." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # PATCH/PUT /messages send all/1 or /messages send all/1.json
  def update_send_all
    @messageTypes = JSON.parse(Setting.where('setting_key = ?', 'MESSAGE_CATEGORY_TYPE').first().setting_value)
    result = true
    respond_to do |format|
      attachment = get_attachment_from_request(params[:message][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @message.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end

      customer_attachment_file = get_attachment_from_request(params[:message][:customer_attachment_file])

      if customer_attachment_file != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(customer_attachment_file)
          if _ok
            @message.customer_attachment = customer_attachment_file.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
      @message.title = params[:message][:title].gsub(/[^[:print:]]/,'')
      @message.title_kr = params[:message][:title_kr].gsub(/[^[:print:]]/,'')
      @message.title_ja = params[:message][:title_ja].gsub(/[^[:print:]]/,'')
      @message.title_cn = params[:message][:title_cn].gsub(/[^[:print:]]/,'')
      
      @message.short_description = params[:message][:short_description].gsub(/[^[:print:]]/,'')
      @message.short_description_kr = params[:message][:short_description_kr].gsub(/[^[:print:]]/,'')
      @message.short_description_ja = params[:message][:short_description_ja].gsub(/[^[:print:]]/,'')
      @message.short_description_cn = params[:message][:short_description_cn].gsub(/[^[:print:]]/,'')
      user_ids = params[:user_ids]
      @message.user_ids = user_ids
      @message.is_draft = 0
      if @message.update(message_update_params)
        format.html { redirect_to messages_url, notice: "Message was successfully created." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def preview
    
  end

  def copy_message
    result = true
    message_old = Message.find(params[:id])
    @message_new = message_old.dup
    @message_new.time_send = nil
    @message_new.is_send = false
    @message_new.is_draft = true
    @message_new.attachment_id = message_old.attachment_id
    @message_new.customer_attachment = nil
    @message_new.user_ids = nil
    @message_new.title = message_old.title.gsub(/[^[:print:]]/,'')
    @message_new.title_kr = message_old.title_kr.gsub(/[^[:print:]]/,'')
    @message_new.title_ja = message_old.title_ja.gsub(/[^[:print:]]/,'')
    @message_new.title_cn = message_old.title_cn.gsub(/[^[:print:]]/,'')
    
    @message_new.short_description = message_old.short_description.gsub(/[^[:print:]]/,'')
    @message_new.short_description_kr = message_old.short_description_kr.gsub(/[^[:print:]]/,'')
    @message_new.short_description_ja = message_old.short_description_ja.gsub(/[^[:print:]]/,'')
    @message_new.short_description_cn = message_old.short_description_cn.gsub(/[^[:print:]]/,'')
    respond_to do |format|
      if @message_new.save
        format.html { redirect_to "/messages/#{@message_new.id}/edit", notice: "Message was successfully dupplicated." }
        format.json { render :show, status: :created, location: @message_new }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message_new.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_customers
    require 'roo'
    if params[:file].present?
      spreadsheet = open_spreadsheet(params[:file])
      header = spreadsheet.row(1)
      desired_columns = ['number', 'title', 'name', 'amount', 'amount2', 'date_month_year', 'time', 'host_phone']
      missing_columns = desired_columns - header

      if !missing_columns.empty?
        render json: { error: "File Deleted - The following columns are missing HEADER ROW in the Excel file: #{missing_columns.join(', ')}" }, status: :bad_request
        return
      end

      number_column_index = header.index('number')
      numbers_seen = Set.new
      duplicate_numbers = []
    
      (2..spreadsheet.last_row).each do |i|
        row_number = spreadsheet.row(i)[number_column_index].to_s
        if row_number.strip.empty?
          next # Skip rows with blank 'number'
        elsif numbers_seen.include?(row_number)
          duplicate_numbers << row_number
        else
          numbers_seen.add(row_number)
        end
      end
    
      if duplicate_numbers.any?
        render json: { error: "File Deleted - Duplicate numbers found in the file: #{duplicate_numbers.uniq.join(', ')}" }, status: :bad_request
        return
      end
    
      data = (2..spreadsheet.last_row).map do |i|
        if spreadsheet.row(i)[0].to_s.present? == true
          next if spreadsheet.row(i)[number_column_index].to_s.strip.empty? # Skip rows with blank 'number'
          Hash[[header, spreadsheet.row(i)].transpose]
        end
      end
      render json: data
      return
    else
      render json: { error: "File missing" }, status: :bad_request
      return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content, :content_ja, :content_kr, :content_cn, :title, :title_ja, :title_kr, :title_cn, :short_description, :short_description_ja, :short_description_kr, :short_description_cn, :language, :is_draft, :is_send, :time_send, :category, :name)
    end

    def message_update_params
      params.require(:message).permit(:content, :content_ja, :content_kr, :content_cn, :title, :title_ja, :title_kr, :title_cn, :short_description, :short_description_ja, :short_description_kr, :short_description_cn, :language, :is_draft, :is_send, :time_send, :category, :name)
    end

    def open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type"
      end
    end

end
