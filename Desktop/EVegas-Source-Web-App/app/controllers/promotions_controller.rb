class PromotionsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_promotion, only: %i[ show edit update destroy subscribers reactions ]

  include CommonModule
  include AttachmentModule
  # GET /promotions or /promotions.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @promotions = Promotion.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @promotions = Promotion.where("name LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /promotions/1 or /promotions/1.json
  def show
  end

  # GET /promotions/new
  def new
    @promotion = Promotion.new
    @promotion_categories = PromotionCategory.all
    @day_of_weeks = JSON.parse(Setting.where('setting_key = ?', 'DAY_OF_WEEK').first().setting_value)
    @day_of_months = JSON.parse(Setting.where('setting_key = ?', 'DAY_OF_MONTH').first().setting_value)
    @month_of_year = JSON.parse(Setting.where('setting_key = ?', 'MONTH_OF_YEAR').first().setting_value)
    @promotion_types = JSON.parse(Setting.where('setting_key = ?', 'PROMOTION_TYPE').first().setting_value)
  end

  # GET /promotions/1/edit
  def edit
    @promotion_categories = PromotionCategory.all
    @day_of_weeks = JSON.parse(Setting.where('setting_key = ?', 'DAY_OF_WEEK').first().setting_value)
    @day_of_months = JSON.parse(Setting.where('setting_key = ?', 'DAY_OF_MONTH').first().setting_value)
    @month_of_year = JSON.parse(Setting.where('setting_key = ?', 'MONTH_OF_YEAR').first().setting_value)
    @promotion_types = JSON.parse(Setting.where('setting_key = ?', 'PROMOTION_TYPE').first().setting_value)
  end

  # POST /promotions or /promotions.json
  def create
    result = true
    @promotion = Promotion.new(promotion_params)
    if !params[:promotion][:day_of_weeks].nil?
      @promotion[:day_of_week] = params[:promotion][:day_of_weeks].reject(&:nil?).map(&:to_s)
    else
      @promotion[:day_of_week] = ""
    end
    if !params[:promotion][:day_of_months].nil?
      @promotion[:day_of_month] = params[:promotion][:day_of_months].reject(&:nil?).map(&:to_i)
    else
      @promotion[:day_of_month] = ""
    end

    respond_to do |format|
      attachment = get_attachment_from_request(params[:promotion][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @promotion.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @promotion.errors, status: :unprocessable_entity }
        end
      end
      
      attachment_banner = get_attachment_from_request(params[:promotion][:attachment_banner])
      if attachment_banner != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment_banner)
          if _ok
            @promotion.banner_id = attachment_banner.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @promotion.errors, status: :unprocessable_entity }
        end
      end
      @promotion = validate_promotion_type(@promotion)
      if @promotion.save
        format.html { redirect_to promotion_url(@promotion), notice: "Promotion was successfully created." }
        format.json { render :show, status: :created, location: @promotion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /promotions/1 or /promotions/1.json
  def update
    result = true
    if !params[:promotion][:day_of_weeks].nil?
      @promotion[:day_of_week] = params[:promotion][:day_of_weeks].reject(&:nil?).map(&:to_s)
    else
      @promotion[:day_of_week] = ""
    end
    if !params[:promotion][:day_of_months].nil?
      @promotion[:day_of_month] = params[:promotion][:day_of_months].reject(&:nil?).map(&:to_i)
    else
      @promotion[:day_of_month] = ""
    end

    respond_to do |format|
      attachment = get_attachment_from_request(params[:promotion][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok != 0
            @promotion.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @promotion.errors, status: :unprocessable_entity }
        end
      end

      attachment_banner = get_attachment_from_request(params[:promotion][:attachment_banner])
      if attachment_banner != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment_banner)
          if _ok
            @promotion.banner_id = attachment_banner.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @promotion.errors, status: :unprocessable_entity }
        end
      end

      @promotion = validate_promotion_type(@promotion)
      if @promotion.update(promotion_update_params)
        format.html { redirect_to promotion_url(@promotion), notice: "Promotion was successfully updated." }
        format.json { render :show, status: :ok, location: @promotion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promotions/1 or /promotions/1.json
  def destroy
    @promotion.destroy

    respond_to do |format|
      format.html { redirect_to promotions_url, notice: "Promotion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  
  def subscribers
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @promotion_subscribers = PromotionSubscriber.select("users.email as number, users.name as name, promotion_subscribers.*")
      .joins(:user => []).where(promotion_id: params[:id]).order('promotion_subscribers.created_at desc')
      .paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  
  end

  def export_subscribers
    promotion_subscribers = PromotionSubscriber.select("users.email as number, users.name as name, promotion_subscribers.*")
      .joins(:user => []).where(promotion_id: params[:id]).order('promotion_subscribers.created_at desc')

    send_file_promotion_subscribers(promotion_subscribers)
  end

  def reactions
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @promotion_reactions = PromotionReaction.select("users.email as number, users.name as name, promotion_reactions.*")
      .joins(:user => []).where(promotion_id: params[:id]).order('promotion_reactions.created_at desc')
      .paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  
  end

  def export_reactions
    promotion_reactions = promotionReaction.select("users.email as number, users.name as name, promotion_reactions.*")
                      .joins(:user => []).where(promotion_id: params[:id]).order('promotion_reactions.created_at desc')

    send_file_promotion_reactions(promotion_reactions)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promotion
      @promotion = Promotion.includes(:promotion_category => []).joins(:promotion_category => []).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def promotion_params
      params.require(:promotion).permit(:name, :terms, :prize, :issue_date, :game_type, :day_of_weeks, :day_of_months, :day_of_season, :time, :remark, :status, :attachment_id, :promotion_category_id, :color, :banner_id, :promotion_type, :is_highlight, :description)
    end

    def promotion_update_params
      params.require(:promotion).permit(:name, :terms, :prize, :issue_date, :game_type, :day_of_weeks, :day_of_months, :day_of_season, :time, :remark, :status, :color, :promotion_type, :is_highlight, :description, :promotion_category_id)
    end

    
    def send_file_promotion_subscribers(lists)
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
  
      sheet.add_row ["Customer Number",
                     "Customer Name",
                     "Time Reaction",
                     "Type Reaction"], style: header_style
  
      lists.each do |item|
        time_read = item.created_at.strftime("%d-%m-%Y %T")
        status_time = item.time_send == nil ? "Subscriber" : "Cancel"
        sheet.add_row [item.number,
                       item.name,
                       item.created_at.strftime("%d-%m-%Y %T"), status_time], types: [:string,:string,:string,:string]
      end
  
      folder_name = "promotion_subscribers"
      filename = "promotion_subscribers_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

    def send_file_promotion_reactions(lists)
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
  
      sheet.add_row ["Customer Number",
                     "Customer Name",
                     "Time Subscription",
                     "Status"], style: header_style
  
      lists.each do |item|
        time_read = item.created_at.strftime("%d-%m-%Y %T")
        status_time = item.reaction_type == 1 ? "Like" : "Cancel"
        sheet.add_row [item.number,
                       item.name,
                       item.created_at.strftime("%d-%m-%Y %T"), status_time], types: [:string,:string,:string,:string]
      end
  
      folder_name = "promotion_reactions"
      filename = "promotion_reactions_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

    def validate_promotion_type(promotion)
      if promotion.promotion_type.to_i == 1
        promotion.day_of_month = ""
        promotion.day_of_season = ""
      elsif promotion.promotion_type.to_i == 2
        promotion.day_of_week = ""
        promotion.day_of_season = ""
      else
        promotion.day_of_week = ""
        promotion.day_of_month = ""
      end
      return promotion
    end
end
