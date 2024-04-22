class MembershipsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_membership, only: %i[ show edit update destroy]

  include CommonModule
  # GET /memberships or /memberships.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @memberships = Membership.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @memberships = Membership.where("name LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    attachment = get_attachment_from_request(params[:membership][:attachment])
    if !is_blank(attachment)
      attachment.save
      @membership.attachment_id = attachment.id
    end
    respond_to do |format|
      if @membership.save
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully created." }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    attachment = get_attachment_from_request(params[:membership][:attachment])
    if !is_blank(attachment)
      attachment.save
      @membership.attachment_id = attachment.id
    end
    respond_to do |format|
      if @membership.update(membership_update_params)
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def export
    membership = Membership.all
    send_file_list(membership)
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to memberships_url, notice: "Membership was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def membership_params
      params.require(:membership).permit(:name, :sub, :point, :attachment_id, :is_show_milestone, :color_milestone, :is_show_name)
    end

    # Only allow a list of trusted parameters through.
    def membership_update_params
      params.require(:membership).permit(:name, :sub, :point, :is_show_milestone, :color_milestone, :is_show_name)
    end

    def send_file_list(memberships)
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
                     "Name",
                     "Sub",
                     "Point",
                     "created_at",
                     "updated_at"], style: header_style
  
      memberships.each do |item|
        language = {}
        sheet.add_row [item.id,
                       item.name,
                       item.sub,
                       item.point,
                       item.created_at,
                       item.updated_at]
      end
  
      folder_name = "Memberships"
      filename = "Memberships_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end
end
