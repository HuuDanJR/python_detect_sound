class UserFirstLoginsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_user_first_login, only: %i[ show edit update destroy ]

  # GET /user_first_logins or /user_first_logins.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    @user_first_logins = UserFirstLogin.includes(:user => []).joins(:user => []).select('users.email as email, users.name as name, users.id, user_first_logins.created_at as last_sign_in_at').order('user_first_logins.created_at desc')
    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @user_first_logins = @user_first_logins.where("email LIKE ? OR name LIKE ?", "%#{@search_query}%", "%#{@search_query}%")
    end
    
    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
      @user_first_logins = @user_first_logins.where("user_first_logins.created_at BETWEEN ? AND ? ", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    @user_first_logins = @user_first_logins.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])

  end

  # GET /user_first_logins/1 or /user_first_logins/1.json
  def show
  end

  # GET /user_first_logins/new
  def new
    @user_first_login = UserFirstLogin.new
  end

  # GET /user_first_logins/1/edit
  def edit
  end

  # POST /user_first_logins or /user_first_logins.json
  def create
    @user_first_login = UserFirstLogin.new(user_first_login_params)

    respond_to do |format|
      if @user_first_login.save
        format.html { redirect_to user_first_login_url(@user_first_login), notice: "User first login was successfully created." }
        format.json { render :show, status: :created, location: @user_first_login }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_first_login.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_first_logins/1 or /user_first_logins/1.json
  def update
    respond_to do |format|
      if @user_first_login.update(user_first_login_params)
        format.html { redirect_to user_first_login_url(@user_first_login), notice: "User first login was successfully updated." }
        format.json { render :show, status: :ok, location: @user_first_login }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_first_login.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_first_logins/1 or /user_first_logins/1.json
  def destroy
    @user_first_login.destroy

    respond_to do |format|
      format.html { redirect_to user_first_logins_url, notice: "User first login was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def export
    search_query = params[:search]
    date_from = params[:date_from]
    date_to = params[:date_to]
    users =  UserFirstLogin.includes(:user => []).joins(:user => []).select('users.email as email, users.name as name, users.id, user_first_logins.created_at as last_sign_in_at').order('user_first_logins.id desc')
    if !is_blank(search_query)
      search_query = search_query.strip
      users = users.where("email LIKE ? OR name LIKE ?", "%#{@search_query}%", "%#{@search_query}%")
    end
    
    if !is_blank(date_from) && !is_blank(date_to)
      date_from = DateTime.parse(date_from)
      date_to = DateTime.parse(date_to).change({ hour: 23, min: 59, sec: 59 })
      users = users.where("user_first_logins.created_at BETWEEN ? AND ? ", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    send_file_list(users)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_first_login
      @user_first_login = UserFirstLogin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_first_login_params
      params.fetch(:user_first_login, {})
    end

    def send_file_list(users)
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
                     "last_sign_in"], style: header_style
  
      users.each do |item|
        sheet.add_row [item.email,
                       item.name,
                       item.last_sign_in_at.strftime("%d-%m-%Y %T")]
      end
  
      folder_name = "users_first_sign_in"
      filename = "users_first_sign_in_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
      tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename
  
      dir_path = File.dirname(tmp_file_path)
      FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)
  
      book.serialize tmp_file_path
      send_file tmp_file_path, filename: filename
    end

end
