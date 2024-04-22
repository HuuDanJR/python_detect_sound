class UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_user, only: [:show, :edit, :update, :destroy,
                                  :activate, :change_password, :execute_change_password, :reset_password, :lock, :unlock]

  include CommonModule

  # GET /users
  # GET /users.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    @status = params[:status].to_i
    @group_query = params[:group]
    @groups = Group.all

    if !is_blank(@group_query)
      @users = User.joins(:user_groups).includes(:groups).where(:user_groups => {:group_id => @group_query.to_i}).all
    else
      @users = User.includes(:groups).all
    end

    if !is_blank(@search_query)
      @users = @users.where("users.email LIKE ? OR users.name LIKE ?", "%#{@search_query}%", "%#{@search_query}%")
    end

    @users = @users.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.group_ids = []
    @groups = Group.all.order('id desc')
  end

  # GET /users/1/edit
  def edit
    group_ids = []
    @user.groups.each do |item|
      group_ids.push(item.id)
    end
    @user.group_ids = group_ids
    @groups = Group.all.order('id desc')
  end

  # POST /users
  # POST /users.json
  def create
    result = true
    @user = User.new(user_params)
    @user.password = PASSWORD_DEFAULT
    @user.skip_confirmation!
    @user.confirm
    @groups = Group.all.order('id desc')
    respond_to do |format|
      if @user.save

        # Save user_group
        group_ids = params[:user][:group_ids].reject(&:empty?).map(&:to_i)
        if !is_blank(group_ids)
          group_ids.each do |item|
            user_group = UserGroup.new
            user_group.user_id = @user.id
            user_group.group_id = item
            ActiveRecord::Base::transaction do
              _ok = user_group.save
              raise ActiveRecord::Rollback, result = false unless _ok
            end
            if result == false
              format.html { render :new }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
          end
        end

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @groups = Group.all.order('id desc')
    respond_to do |format|
      if @user.update(update_params)

        # Save user_group
        # Get current group
        current_group_ids = []
        @user.groups.each do |item|
          current_group_ids.push(item.id)
        end
        # Get edit group
        group_ids = params[:user][:group_ids].reject(&:empty?).map(&:to_i)

        delete_group_ids = current_group_ids - group_ids
        if !is_blank(delete_group_ids)
          delete_group_ids.each do |item|
            UserGroup.where('user_id = ? AND group_id = ?', @user.id, item).destroy_all
          end
        end

        new_group_ids = group_ids - current_group_ids
        if !is_blank(new_group_ids)
          new_group_ids.each do |item|
            user_group = UserGroup.new
            user_group.user_id = @user.id
            user_group.group_id = item
            user_group.save
          end
        end

        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /users/1/activated
  def activate
    @user.confirm
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully activated.' }
      format.json { head :no_content }
    end
  end

  # GET /users/1/change_password
  def change_password
  end

  # POST /users/1/change_password
  def execute_change_password
    respond_to do |format|
      if @user.reset_password(change_password_params["password"], change_password_params["password_confirmation"])
        format.html { redirect_to users_url, notice: 'User was successfully updated password.' }
        format.json { head :no_content }
      else
        format.html { render :change_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/reset-password
  def reset_password
    user = User.find_by(id: params[:id])
    customer = Customer.find_by(number: user.email)
    notice_pass = 'User was successfully reset password by date (MM/YY).'
    if customer != nil
      user.password = customer.date_of_birth.strftime("%m%y") # PIN code default
    else
      notice_pass = 'User was successfully reset password default.'
      user.password = PASSWORD_DEFAULT # PIN code default
    end
    user.skip_confirmation!
    
    ActiveRecord::Base::transaction do
      _ok = user.save
      if _ok
        
      else
        respond_to do |format|
          format.html { redirect_to users_url, notice: 'Fail' }
          format.json { head :no_content }
        end
        raise ActiveRecord::Rollback, result = false unless _ok
      end
    end
    
    respond_to do |format|
      format.html { redirect_to users_url, notice: notice_pass }
      format.json { head :no_content }
    end
  end

  # GET /users/1/locked
  def lock
    @user.lock_access!({send_instructions: false})
    @user.invalidate_all_sessions!
    respond_to do |format|
      @user[:session_token] = SecureRandom.uuid
      @user.save!
      authtoken = OauthAccessToken.where('resource_owner_id = ?', @user.id).order('id desc').first
      if authtoken != nil
        authtoken.revoked_at = DateTime.now
        authtoken.save!
      end
      format.html { redirect_to users_url, notice: 'User was successfully locked.' }
      format.json { head :no_content }
    end
  end

  # GET /users/1/unlocked
  def unlock
    @user.unlock_access!
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully unlocked.' }
      format.json { head :no_content }
    end
  end

    # GET /users.json
  def latest_login
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    @users = User.includes(:groups).where('current_sign_in_ip IS NOT NULL OR sign_in_count > 0 OR last_sign_in_at IS NOT NULL OR current_sign_in_ip IS NOT NULL OR last_sign_in_ip IS NOT NULL OR current_sign_in_at IS NOT NULL').order('users.last_sign_in_at desc')
    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @users = @users.where("email LIKE ? OR name LIKE ?", "%#{@search_query}%", "%#{@search_query}%").order('users.last_sign_in_at desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
    
    @date_from = params[:date_from]
    @date_to = params[:date_to]
    if !is_blank(@date_from) && !is_blank(@date_to)
      date_from = DateTime.parse(@date_from)
      date_to = DateTime.parse(@date_to).change({ hour: 23, min: 59, sec: 59 })
      @users = @users.where("( users.last_sign_in_at BETWEEN ? AND ? ) OR ( users.current_sign_in_at BETWEEN ? AND ? ) OR ( users.confirmation_sent_at BETWEEN ? AND ? )", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"), date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"), date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    @users = @users.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  def export
    search_query = params[:search]
    date_from = params[:date_from]
    date_to = params[:date_to]
    users = User.includes(:groups).where("current_sign_in_ip IS NOT NULL OR sign_in_count > 0 OR last_sign_in_at IS NOT NULL OR current_sign_in_ip IS NOT NULL OR last_sign_in_ip IS NOT NULL OR current_sign_in_at IS NOT NULL").order('users.last_sign_in_at desc')
    if !is_blank(search_query)
      search_query = search_query.strip
      users = users.where("email LIKE ? OR name LIKE ?", "%#{@search_query}%", "%#{@search_query}%").order('users.last_sign_in_at desc')
    end
    
    if !is_blank(date_from) && !is_blank(date_to)
      date_from = DateTime.parse(date_from)
      date_to = DateTime.parse(date_to).change({ hour: 23, min: 59, sec: 59 })
      users = users.where("( users.last_sign_in_at BETWEEN ? AND ? ) OR ( users.current_sign_in_at BETWEEN ? AND ? ) OR ( users.confirmation_sent_at BETWEEN ? AND ? )", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"), date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"), date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
    end

    send_file_list(users)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    # params.fetch(:user, {}).permit(:email)
    params.require(:user).permit(:email, :name, :group_ids)
  end

  def update_params
    params.require(:user).permit(:name, :group_ids)
  end

  def change_password_params
    params.require(:user).permit(:password, :password_confirmation)
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
      date_sign_in = "-"
      if !item.last_sign_in_at.nil?
        date_sign_in = item.last_sign_in_at.strftime("%d-%m-%Y %T")
      elsif !item.current_sign_in_at.nil?
        date_sign_in = item.current_sign_in_at.strftime("%d-%m-%Y %T")
      elsif !item.confirmation_sent_at.nil?
        date_sign_in = item.confirmation_sent_at.strftime("%d-%m-%Y %T")
      end
      
      sheet.add_row [item.email,
                     item.name,
                     date_sign_in]
    end

    folder_name = "users_sign_in"
    filename = "users_sign_in_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename

    dir_path = File.dirname(tmp_file_path)
    FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

    book.serialize tmp_file_path
    send_file tmp_file_path, filename: filename
  end

end
