class JackpotMachinesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_jackpot_machine, only: %i[ show edit update destroy ]

  include CommonModule

  # GET /jackpot_machines or /jackpot_machines.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @jackpot_machines = JackpotMachine.includes(:jackpot_game_type => []).joins(:jackpot_game_type => []).order('jackpot_machines.id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @jackpot_machines = JackpotMachine.includes(:jackpot_game_type => []).joins(:jackpot_game_type => []).where("jackpot_machines.mc_name LIKE ?", "%#{@search_query}%").order('jackpot_machines.id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
      @jackpot_machines = @jackpot_machines.where("jp_date BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S")).order('jackpot_machines.id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end

  end

  # GET /jackpot_machines/1 or /jackpot_machines/1.json
  def show
    @jackpot_machines = JackpotMachine.includes(:jackpot_game_type => []).joins(:jackpot_game_type => [])
  end

  # GET /jackpot_machines/new
  def new
    @jackpot_machine = JackpotMachine.new
    @jackpot_machine[:jp_date] = DateTime.now
    @jackpotGameTypes = JackpotGameType.order('id desc')
  end

  # GET /jackpot_machines/1/edit
  def edit
    @jackpotGameTypes = JackpotGameType.order('id desc')
  end

  # POST /jackpot_machines or /jackpot_machines.json
  def create
    @jackpot_machine = JackpotMachine.new(jackpot_machine_params)

    respond_to do |format|
      if @jackpot_machine.save
        format.html { redirect_to jackpot_machine_url(@jackpot_machine), notice: "Jackpot machine was successfully created." }
        format.json { render :show, status: :created, location: @jackpot_machine }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @jackpot_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jackpot_machines/1 or /jackpot_machines/1.json
  def update
    respond_to do |format|
      if @jackpot_machine.update(jackpot_machine_params)
        format.html { redirect_to jackpot_machine_url(@jackpot_machine), notice: "Jackpot machine was successfully updated." }
        format.json { render :show, status: :ok, location: @jackpot_machine }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jackpot_machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jackpot_machines/1 or /jackpot_machines/1.json
  def destroy
    @jackpot_machine.destroy

    respond_to do |format|
      format.html { redirect_to jackpot_machines_url, notice: "Jackpot machine was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # EXPORT /officers/export
  def export    
    jackpot_machines = JackpotMachine.includes(:jackpot_game_type => []).joins(:jackpot_game_type => []).order('jackpot_machines.jp_date desc')

    search_query = params[:search]
    if !is_blank(search_query)
      search_query = search_query.strip
      jackpot_machines = jackpot_machines..where("jackpot_machines.mc_number LIKE ?", "%#{@search_query}%")
    end
    date_from = params[:date_from]
    date_to = params[:date_to]
    if !is_blank(date_from) && !is_blank(date_to)
      date_from = DateTime.parse(date_from)
      date_to = DateTime.parse(date_to).change({ hour: 23, min: 59, sec: 59 })
      jackpot_machines = jackpot_machines.where("jackpot_machines.jp_date BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end
    send_file_list(jackpot_machines)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jackpot_machine
      @jackpot_machine = JackpotMachine.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jackpot_machine_params
      params.require(:jackpot_machine).permit(:mc_number, :mc_name, :jp_date, :jp_value, :jackpot_game_type_id)
    end

    def send_file_list(jackpot_machines)
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
  
      sheet.add_row ["GamingDate",
                     "Item",
                     "Game Theme",
                     "Detail"], style: header_style
  
      jackpot_machines.each do |item|
        item_number = "Machine Number " + item.mc_number.to_s
        item_game_theme = item.jackpot_game_type != nil ? item.jackpot_game_type.name : ""
        amount = "Jackpot - Amount $" + item.jp_value.to_f.to_s
        sheet.add_row [item.jp_date,
                       item_number,
                       item_game_theme,
                       amount]
      end
  
      folder_name = "jackpot_machines"
      filename = "jackpot_machines_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end
end
