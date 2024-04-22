class OffersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_offer, only: %i[ show edit update destroy subscribers reactions]

  include CommonModule
  include AttachmentModule
  # GET /offers or /offers.json
  def index
    @page = params[:page]
    @offer_type = params[:offer_type]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    @offers = Offer.order('id desc')
    if !is_blank(@offer_type)
      @offers = @offers.where('offer_type = ?', @offer_type.to_i)
    end

    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @offers = @offers.where("title LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
    @offers = @offers.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /offers/1 or /offers/1.json
  def show
  end

  # GET /offers/new
  def new
    @offer = Offer.new
    @offer.publish_date = Time.zone.now
    @offer.time_end = Time.zone.now
    @offertypes = JSON.parse(Setting.where('setting_key = ?', 'OFFER_TYPE_CONFIG').first().setting_value).reverse()
  end

  # GET /offers/1/edit
  def edit
    @offertypes = JSON.parse(Setting.where('setting_key = ?', 'OFFER_TYPE_CONFIG').first().setting_value).reverse()
  end

  # POST /offers or /offers.json
  def create
    result = true
    @offertypes = JSON.parse(Setting.where('setting_key = ?', 'OFFER_TYPE_CONFIG').first().setting_value).reverse()
    @offer = Offer.new(offer_params)

    respond_to do |format|
      attachment = get_attachment_from_request(params[:offer][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @offer.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @offer.errors, status: :unprocessable_entity }
        end
      end

      banner_attachment = get_attachment_from_request(params[:offer][:banner_attachment_file])
      if banner_attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(banner_attachment)
          if _ok != 0
            @offer.banner_attachment = banner_attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @offer.errors, status: :unprocessable_entity }
        end
      end
      

      if @offer.save
        format.html { redirect_to offer_url(@offer), notice: "Offer was successfully created." }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1 or /offers/1.json
  def update
    result = true
    @offertypes = JSON.parse(Setting.where('setting_key = ?', 'OFFER_TYPE_CONFIG').first().setting_value).reverse()
    respond_to do |format|
      attachment = get_attachment_from_request(params[:offer][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok != 0
            @offer.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @offer.errors, status: :unprocessable_entity }
        end
      end

      banner_attachment = get_attachment_from_request(params[:offer][:banner_attachment_file])
      if banner_attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(banner_attachment)
          if _ok != 0
            @offer.banner_attachment = banner_attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @offer.errors, status: :unprocessable_entity }
        end
      end
      
      if @offer.update(offer_update_params)
        format.html { redirect_to offer_url(@offer), notice: "Offer was successfully updated." }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1 or /offers/1.json
  def destroy
    @offer.destroy

    respond_to do |format|
      format.html { redirect_to offers_url, notice: "Offer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def subscribers
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @offer_subscribers = OfferSubscriber.select("users.email as number, users.name as name, offer_subscribers.*")
      .joins(:user => []).where(offer_id: params[:id]).order('offer_subscribers.created_at desc')
      .paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  
  end

  def export_subscribers
    offer_subscribers = OfferSubscriber.select("users.email as number, users.name as name, offer_subscribers.*")
      .joins(:user => []).where(offer_id: params[:id]).order('offer_subscribers.created_at desc')

    send_file_offer_subscribers(offer_subscribers)
  end

  def reactions
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @offer_reactions = OfferReaction.select("users.email as number, users.name as name, offer_reactions.*")
      .joins(:user => []).where(offer_id: params[:id]).order('offer_reactions.created_at desc')
      .paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  
  end

  def export_reactions
    offer_reactions = OfferReaction.select("users.email as number, users.name as name, offer_reactions.*")
                      .joins(:user => []).where(offer_id: params[:id]).order('offer_reactions.created_at desc')

    send_file_offer_reactions(offer_reactions)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def offer_params
      params.require(:offer).permit(:title, :title_ja, :title_kr, :title_cn, :description, :description_ja, :description_kr, :description_cn, :url_news, :publish_date, :time_end, :is_highlight, :offer_type, :attachment_id, :is_discover, :banner_attachment, :index_order)
    end
    
    def offer_update_params
      params.require(:offer).permit(:title, :title_ja, :title_kr, :title_cn, :description, :description_ja, :description_kr, :description_cn, :url_news, :publish_date, :time_end, :is_highlight, :offer_type, :is_discover, :index_order)
    end

    def send_file_offer_subscribers(lists)
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
                       item.created_at.strftime("%d-%m-%Y %T"), status_time], types: [:string,:string,:string]
      end
  
      folder_name = "offer_subscribers"
      filename = "offer_subscribers_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

    def send_file_offer_reactions(lists)
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
        status_time = item.reaction_type == 1 ? "Like" : (offer.reaction_type == 0 ? "Dislike" : "Cancel")
        sheet.add_row [item.number,
                       item.name,
                       item.created_at.strftime("%d-%m-%Y %T"), 
                       status_time], types: [:string,:string,:string,:string]
      end
  
      folder_name = "offer_reactions"
      filename = "offer_reactions_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end
end
