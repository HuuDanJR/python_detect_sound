class StaffIntroducesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_staff_introduce, only: %i[ show edit update destroy ]

  # GET /staff_introduces or /staff_introduces.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @staff_introduces = StaffIntroduce.select('staffs.id, staffs.name, staffs.nick_name, staffs.code, staff_introduces.customer_number, staff_introduces.customer_name, staff_introduces.created_at')
                                      .includes(:staff => []).joins(:staff => []).order('staff_introduces.id desc')
    @search_query = params[:search]
    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @staff_introduces = @staff_introduces.where("staffs.code = ?", "#{@search_query}")
    end
    
    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
      @staff_introduces = @staff_introduces.where("staff_introduces.created_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    @staff_introduces = @staff_introduces.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /staff_introduces/1 or /staff_introduces/1.json
  def show
  end

  # GET /staff_introduces/new
  def new
    @staff_introduce = StaffIntroduce.new
  end

  # GET /staff_introduces/1/edit
  def edit
  end

  # POST /staff_introduces or /staff_introduces.json
  def create
    @staff_introduce = StaffIntroduce.new(staff_introduce_params)

    respond_to do |format|
      if @staff_introduce.save
        format.html { redirect_to staff_introduce_url(@staff_introduce), notice: "Staff introduce was successfully created." }
        format.json { render :show, status: :created, location: @staff_introduce }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @staff_introduce.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staff_introduces/1 or /staff_introduces/1.json
  def update
    respond_to do |format|
      if @staff_introduce.update(staff_introduce_params)
        format.html { redirect_to staff_introduce_url(@staff_introduce), notice: "Staff introduce was successfully updated." }
        format.json { render :show, status: :ok, location: @staff_introduce }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @staff_introduce.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_introduces/1 or /staff_introduces/1.json
  def destroy
    @staff_introduce.destroy

    respond_to do |format|
      format.html { redirect_to staff_introduces_url, notice: "Staff introduce was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def export
    search_query = params[:search]
    date_from = params[:date_from]
    date_to = params[:date_to]
    staff_introduces = StaffIntroduce.select('staffs.id, staffs.name, staffs.nick_name, staffs.code, staff_introduces.customer_number, staff_introduces.customer_name, staff_introduces.created_at')
    .includes(:staff => []).joins(:staff => []).order('staff_introduces.id desc')
    if !is_blank(search_query)
      search_query = search_query.strip
      staff_introduces = staff_introduces.where("staffs.code = ?", "#{@search_query}")
    end
    
    if !is_blank(date_from) && !is_blank(date_to)
      date_from = DateTime.parse(date_from)
      date_to = DateTime.parse(date_to).change({ hour: 23, min: 59, sec: 59 })
      staff_introduces = staff_introduces.where("staff_introduces.created_at BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    send_file_list(staff_introduces)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff_introduce
      @staff_introduce = StaffIntroduce.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def staff_introduce_params
      params.fetch(:staff_introduce, {})
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
  
      sheet.add_row ["customer_number",
                     "customer_name",
                     "staff_code",
                     "staff_name",
                     "staff_nick_name",
                     "time"], style: header_style
  
      lists.each do |item|
        language = {}
        sheet.add_row [item.customer_number,
                       item.customer_name,
                       item.code.to_s,
                       item.name,
                       item.nick_name,
                       item.created_at.strftime("%d-%m-%Y %T")], types: [:string,:string,:string,:string,:string, nil]
      end
  
      folder_name = "staff_introduces"
      filename = "staff_introduces_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end
  
end
