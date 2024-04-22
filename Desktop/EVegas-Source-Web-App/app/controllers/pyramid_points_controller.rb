class PyramidPointsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_pyramid_point, only: %i[ show edit update destroy]

  include CommonModule
  # GET /pyramid_points or /pyramid_points.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @pyramid_points = PyramidPoint.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @pyramid_points = PyramidPoint.where("prize LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /pyramid_points/1 or /pyramid_points/1.json
  def show
  end

  # GET /pyramid_points/new
  def new
    @pyramid_point = PyramidPoint.new
  end

  # GET /pyramid_points/1/edit
  def edit
  end

  # POST /pyramid_points or /pyramid_points.json
  def create
    @pyramid_point = PyramidPoint.new(pyramid_point_params)

    respond_to do |format|
      if @pyramid_point.save
        format.html { redirect_to pyramid_point_url(@pyramid_point), notice: "Pyramid point was successfully created." }
        format.json { render :show, status: :created, location: @pyramid_point }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pyramid_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pyramid_points/1 or /pyramid_points/1.json
  def update
    respond_to do |format|
      if @pyramid_point.update(pyramid_point_params)
        format.html { redirect_to pyramid_point_url(@pyramid_point), notice: "Pyramid point was successfully updated." }
        format.json { render :show, status: :ok, location: @pyramid_point }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pyramid_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pyramid_points/1 or /pyramid_points/1.json
  def destroy
    @pyramid_point.destroy

    respond_to do |format|
      format.html { redirect_to pyramid_points_url, notice: "Pyramid point was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def export
    pyramidPoints = PyramidPoint.all
    send_file_list(pyramidPoints)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pyramid_point
      @pyramid_point = PyramidPoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pyramid_point_params
      params.require(:pyramid_point).permit(:prize, :min_point, :max_point)
    end

    def send_file_list(pyramidPoints)
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
                     "Prize",
                     "Min point",
                     "Max point",
                     "created_at",
                     "updated_at"], style: header_style
  
                     pyramidPoints.each do |item|
        language = {}
        sheet.add_row [item.id,
                       item.prize,
                       item.min_point,
                       item.max_point,
                       item.created_at,
                       item.updated_at]
      end
  
      folder_name = "PramidPoints"
      filename = "PramidPoints_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end
end
