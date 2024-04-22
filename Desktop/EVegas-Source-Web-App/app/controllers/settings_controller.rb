class SettingsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_setting, only: %i[ show edit update destroy ]

  include CommonModule

  # GET /settings or /settings.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @settings = Setting.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @settings = Setting.where("setting_key LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /settings/1 or /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings or /settings.json
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to setting_url(@setting), notice: "Setting was successfully created." }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1 or /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to setting_url(@setting), notice: "Setting was successfully updated." }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1 or /settings/1.json
  def destroy
    @setting.destroy

    respond_to do |format|
      format.html { redirect_to settings_url, notice: "Setting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /settings/mail or /settings/mail.json
  def edit_mail
    @mail = {}
    @mail['mail_smtp_address'] = Setting.where('setting_key = ?', 'MAIL_SMTP_ADDRESS').first!.setting_value
    @mail['mail_smtp_port'] = Setting.where('setting_key = ?', 'MAIL_SMTP_PORT').first!.setting_value
    @mail['mail_smtp_domain'] = Setting.where('setting_key = ?', 'MAIL_SMTP_DOMAIN').first!.setting_value
    @mail['mail_smtp_user_name'] = Setting.where('setting_key = ?', 'MAIL_SMTP_USER_NAME').first!.setting_value
    @mail['mail_smtp_password'] = Setting.where('setting_key = ?', 'MAIL_SMTP_PASSWORD').first!.setting_value
    @mail['mail_smtp_authentication'] = Setting.where('setting_key = ?', 'MAIL_SMTP_AUTHENTICATION').first!.setting_value
  end

  # POST /settings/mail or /settings/mail.json
  def update_mail
    result = true

    mail_smtp_address = Setting.where('setting_key = ?', 'MAIL_SMTP_ADDRESS').first!
    mail_smtp_port = Setting.where('setting_key = ?', 'MAIL_SMTP_PORT').first!
    mail_smtp_domain = Setting.where('setting_key = ?', 'MAIL_SMTP_DOMAIN').first!
    mail_smtp_user_name = Setting.where('setting_key = ?', 'MAIL_SMTP_USER_NAME').first!
    mail_smtp_password = Setting.where('setting_key = ?', 'MAIL_SMTP_PASSWORD').first!
    mail_smtp_authentication = Setting.where('setting_key = ?', 'MAIL_SMTP_AUTHENTICATION').first!

    mail_smtp_address.setting_value = params[:mail][:mail_smtp_address]
    mail_smtp_port.setting_value = params[:mail][:mail_smtp_port]
    mail_smtp_domain.setting_value = params[:mail][:mail_smtp_domain]
    mail_smtp_user_name.setting_value = params[:mail][:mail_smtp_user_name]
    mail_smtp_password.setting_value = params[:mail][:mail_smtp_password]
    mail_smtp_authentication.setting_value = params[:mail][:mail_smtp_authentication]

    ActiveRecord::Base::transaction do
      _ok = mail_smtp_address.save
      _ok = mail_smtp_port.save
      _ok = mail_smtp_domain.save
      _ok = mail_smtp_user_name.save
      _ok = mail_smtp_password.save
      _ok = mail_smtp_authentication.save
      raise ActiveRecord::Rollback, result = false unless _ok
    end

    respond_to do |format|
      if result
        ActionMailer::Base.smtp_settings = {
            :address => 'smtp.sendgrid.net',
            :port => '587',
            :authentication => :plain,
            :user_name => Rails.application.credentials.dig(:user_name),
            :password => Rails.application.credentials.dig(:password),
            :domain => 'heroku.com',
            :enable_starttls_auto => true
        }

        format.html { redirect_to settings_url, notice: "Setting was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render :edit_mail, status: :unprocessable_entity }
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  # GET /settings/sendmail or /settings/sendmail.json
  def send_email_testing
    mail_smtp_address = params[:mail_smtp_address]
    mail_smtp_port = params[:mail_smtp_port]
    mail_smtp_domain = params[:mail_smtp_domain]
    mail_smtp_user_name = params[:mail_smtp_user_name]
    mail_smtp_password = params[:mail_smtp_password]
    mail_smtp_authentication = params[:mail_smtp_authentication]
    mail_to = params[:mail_to]
    mail_subject = "Gửi email kiểm tra"
    mail_body = "Chúc mừng, email đã được gửi thành công!"
    # Thread.new do
    SystemMailer.send_email_testing(mail_smtp_address, mail_smtp_port, mail_smtp_domain, mail_smtp_user_name, mail_smtp_password, mail_smtp_authentication, mail_to, mail_subject, mail_body).deliver_now
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def setting_params
      params.require(:setting).permit(:setting_key, :setting_value, :description)
    end
end
