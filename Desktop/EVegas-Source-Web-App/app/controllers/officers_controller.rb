require 'securerandom'

class OfficersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_officer, only: [:show, :edit, :update, :destroy, :delete, :update_status_active]

  include CommonModule
  include RedisCacheModule
  include AttachmentModule

  # GET /officers
  # GET /officers.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @officers = Officer.where("status = 1").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @officers = Officer.where("name LIKE ? AND status = 1", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /officers/1
  # GET /officers/1.json
  def show
  end

  # GET /officers/new
  def new
    @officer = Officer.new
    customerUser = Customer.select('user_id').where('user_id IS NOT NULL')
    officerUser = Officer.select('user_id').where('user_id IS NOT NULL')
    group_role_id = JSON.parse(Setting.where('setting_key = ?', 'GROUP_ROLE_HOST_TEAM_MAPPING_ID').first().setting_value)
    user_groups = UserGroup.joins(:user).select('user_id').where('user_groups.group_id = ?', group_role_id.to_i)
    
    @users = User.select('users.id, users.email').where('users.id not in ( ? ) AND users.id not in ( ? ) AND users.id in ( ? )', customerUser, officerUser, user_groups)
    @languages = JSON.parse(Setting.where('setting_key = ?', 'LANGUAGE_SUPPORT').first().setting_value)
  end

  # GET /officers/1/edit
  def edit
    where_query = 'user_id IS NOT NULL'
    if !@officer.user_id.nil?
      where_query = 'user_id != ' + @officer.user_id.to_s
    end
    officerUser = Officer.joins(:user).select('user_id').where(where_query)
    customerUser = Customer.joins(:user).select('user_id').where(where_query)
    group_role_id = JSON.parse(Setting.where('setting_key = ?', 'GROUP_ROLE_HOST_TEAM_MAPPING_ID').first().setting_value)
    user_groups = UserGroup.joins(:user).select('user_id').where('user_groups.group_id = ?', group_role_id.to_i)

    @users = User.select('users.id, users.email').where('users.id not in ( ? ) AND users.id not in ( ? ) AND users.id in ( ? )', customerUser, officerUser, user_groups)
    @languages = JSON.parse(Setting.where('setting_key = ?', 'LANGUAGE_SUPPORT').first().setting_value)
  end

  # POST /officers
  # POST /officers.json
  def create
    result = true
    @officer = Officer.new(officer_params)

    respond_to do |format|
      attachment = get_attachment_from_request(params[:officer][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @officer.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :new }
          format.json { render json: @officer.errors, status: :unprocessable_entity }
        end
      end
      
      if @officer.save

        format.html { redirect_to @officer, notice: t(:officer_create_success) }
        format.json { render :show, status: :created, location: @officer }
      else
        format.html { render :new }
        format.json { render json: @officer.errors, status: :unprocessable_entity }
      end

    end
  end

  # PATCH/PUT /officers/1
  # PATCH/PUT /officers/1.json
  def update
    result = true
    respond_to do |format|
      attachment = get_attachment_from_request(params[:officer][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @officer.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @officer.errors, status: :unprocessable_entity }
        end
      end

      if @officer.update(officer_update_params)

        format.html { redirect_to @officer, notice: t(:officer_update_success) }
        format.json { render :show, status: :updated, location: @officer }
      else
        format.html { render :new }
        format.json { render json: @officer.errors, status: :unprocessable_entity }
      end

    end
  end

  # DELETE /officers/1
  # DELETE /officers/1.json
  def destroy
    @officer.destroy
    respond_to do |format|
      format.html { redirect_to officers_url, notice: t(:officer_delete_success) }
      format.json { head :no_content }
    end
  end

  def delete
    officer = Officer.find(params[:id])
    officer.status = -1

    if officer.save
      # redis_cache_delete_by_prefix(Officer)

      respond_to do |format|
        format.html { redirect_to officers_url, notice: t(:delete_success) }
        format.json { head :no_content }
      end
    else
      
      respond_to do |format|
        format.html { redirect_to officers_url, notice: t(:delete_fail) }
        format.json { head :no_content }
      end
    end
  end

  # def update_status_by_user_id
  #   officer = Officer.find_by user_id: params[:id]
  #   officer.online = 1

  #   if officer.save
  #     respond_to do |format|
  #       format.html { redirect_to request.referer, notice: 'Checkin Success' }
  #     end
  #   else
  #     respond_to do |format|
  #       format.html { redirect_to request.referer, alert: 'Checkin Fail' }
  #     end
  #   end
  # end

  def update_status_active
    officer = Officer.where('id = ?', params[:id]).first
    if !officer.nil?
      officer[:online] = params[:online]
      ActiveRecord::Base::transaction do
        if officer.save
          render json: officer
        else
          render json: nil
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  # EXPORT /officers/export
  def export
    officers = Officer.all
    send_file_list(officers)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_officer
    @officer = Officer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def officer_params
    params.require(:officer).permit(:name, :date_of_birth, :gender, :phone, :home_town, :nationality, :language_support, :online, :status, :attachment_id, :user_id, :is_reception)
  end

  def officer_update_params
    params.require(:officer).permit(:name, :date_of_birth, :gender, :phone, :home_town, :nationality, :language_support, :online, :status, :user_id, :is_reception)
  end

  def send_file_list(officers)
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
                   "name",
                   "date_of_birth",
                   "gender",
                   "phone",
                   "home_town",
                   "nationality",
                   "language_support",
                   "status",
                   "created_at",
                   "updated_at"], style: header_style

    officers.each do |item|
      language = {}
      sheet.add_row [item.id,
                     item.name,
                     item.date_of_birth,
                     item.gender,
                     item.phone,
                     item.home_town,
                     item.nationality,
                     item.language_support,
                     item.status,
                     item.created_at,
                     item.updated_at]
    end

    folder_name = "officers"
    filename = "officers_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename

    dir_path = File.dirname(tmp_file_path)
    FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

    book.serialize tmp_file_path
    send_file tmp_file_path, filename: filename
  end
end
