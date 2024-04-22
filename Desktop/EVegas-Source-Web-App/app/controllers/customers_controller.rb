class CustomersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_customer, only: %i[ show edit update destroy ]

  include CommonModule
  include AttachmentModule
  include CustomerModule
  
  # GET /customers or /customers.json
  def index
    @sort = params[:sort].to_i
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    if is_blank(@sort)
      @sort = 0
    end
    @search_query = params[:search]
    order = 'id desc'
    if @sort == 0
      order = 'id desc'
    else
      order = 'last_update_frame_point desc'
    end

    if is_blank(@search_query)
      @customers = Customer.order(order).paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @customers = Customer.where("customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ? OR customers.number = ?", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%", "#{@search_query}").order(order).paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /customers/1 or /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    customerUser = Customer.select('user_id').where('user_id IS NOT NULL')
    officerUser = Officer.select('user_id').where('user_id IS NOT NULL')
    @users = User.select('users.id, users.email').where('users.id not in ( ? ) AND users.id not in ( ? )', customerUser, officerUser)
  end

  # GET /customers/1/edit
  def edit
    where_query = 'user_id IS NOT NULL'
    if !@customer.user_id.nil?
      where_query = 'user_id != ' + @customer.user_id.to_s
    end
    customerUser = Customer.joins(:user).select('user_id').where(where_query)
    officerUser = Officer.joins(:user).select('user_id').where(where_query)
    @users = User.select('users.id, users.email').where('users.id not in ( ? ) AND users.id not in ( ? )', customerUser, officerUser)
  end

  # POST /customers or /customers.json
  def create
    result = true
    @customer = Customer.new(customer_params)    
    respond_to do |format|
      attachment = get_attachment_from_request(params[:customer][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @customer.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :new }
          format.json { render json: @customer.errors, status: :unprocessable_entity }
        end
      end
      
      if @customer.save
        format.html { redirect_to @customer, notice: t(:customer_create_success) }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end

    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    result = true
    respond_to do |format|
      attachment = get_attachment_from_request(params[:customer][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok != 0
            @customer.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @customer.errors, status: :unprocessable_entity }
        end
      end

      if @customer.update(customer_update_params)
        format.html { redirect_to @customer, notice: t(:customer_update_success) }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end

    end

  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url, notice: "Customer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # EXPORT /Customers/export
  def export
    customers = Customer.all
    send_file_list(customers)
  end

  def synchronize_all
    result = true
    customer_data = get_customers_from_neon()
    customer_data.each do |item|
      # puts item[:forename] + ' - ' + item[:number] + ' - ' + item[:card_number]
      # Get customer extra info by card
      customer_extra_info = get_customer_by_card(item[:card_number])
      if !customer_extra_info.nil?
        customer = Customer.find_by(number: item[:number])
        if customer.nil?
          # Create a new customer
          customer = Customer.new
          customer.age = item[:age]
          customer.card_number = item[:card_number]
          customer.cashless_balance = item[:cashless_balance]
          customer.colour = item[:colour]
          customer.colour_html = item[:colour_html]
          customer.comp_balance = item[:comp_balance]
          customer.comp_status_colour = item[:comp_status_colour]
          customer.comp_status_colour_html = item[:comp_status_colour_html]
          customer.forename = item[:forename]
          customer.freeplay_balance = item[:freeplay_balance]
          customer.gender = item[:gender]
          customer.has_online_account = item[:has_online_account]
          customer.hide_comp_balance = item[:hide_comp_balance]
          customer.is_guest = item[:is_guest]
          customer.loyalty_balance = item[:loyalty_balance]
          customer.loyalty_points_available = item[:loyalty_points_available]
          customer.membership_type_name = item[:membership_type_name]
          customer.middle_name = item[:middle_name]
          customer.number = item[:number]
          customer.player_tier_name = item[:player_tier_name]
          customer.player_tier_short_code = item[:player_tier_short_code]
          customer.premium_player = item[:premium_player]
          customer.surname = item[:surname]
          customer.title = item[:title]
          customer.valid_membership = item[:valid_membership]
          customer.date_of_birth = customer_extra_info[:date_of_birth]
          customer.membership_last_issue_date = customer_extra_info[:membership_last_issue_date]

          # Create a new user
          user = User.find_by(email: item[:number])
          if user.nil?
            user = User.new
            user.email = item[:number]
            user.name = item[:forename]
            user.password = get_pin_code_customer_default(customer_extra_info[:date_of_birth]) # PIN code default
            user.skip_confirmation!
            ActiveRecord::Base::transaction do
              _ok = user.save
              raise ActiveRecord::Rollback, result = false unless _ok
              customer.user_id = user.id
            end
            
            # Create user_group
            user_group = UserGroup.new
            user_group.user_id = user.id
            user_group.group_id = 2
            ActiveRecord::Base::transaction do
              _ok = user_group.save
              raise ActiveRecord::Rollback, result = false unless _ok
            end
          end

          # Create a new customer image
          image_base64 = customer_extra_info[:picture]
          attachment = get_attachment_base64(image_base64, customer.number)
          if attachment != nil
            ActiveRecord::Base::transaction do
              _ok = create_attachment_file(attachment)
              raise ActiveRecord::Rollback, result = false unless _ok
              customer.attachment_id = attachment.id
            end
          end

          ActiveRecord::Base::transaction do
            _ok = customer.save
            raise ActiveRecord::Rollback, result = false unless _ok
          end
        else
          # Update a existed customer
          customer.age = item[:age]
          customer.card_number = item[:card_number]
          customer.cashless_balance = item[:cashless_balance]
          customer.colour = item[:colour]
          customer.colour_html = item[:colour_html]
          customer.comp_balance = item[:comp_balance]
          customer.comp_status_colour = item[:comp_status_colour]
          customer.comp_status_colour_html = item[:comp_status_colour_html]
          customer.forename = item[:forename]
          customer.freeplay_balance = item[:freeplay_balance]
          customer.gender = item[:gender]
          customer.has_online_account = item[:has_online_account]
          customer.hide_comp_balance = item[:hide_comp_balance]
          customer.is_guest = item[:is_guest]
          customer.loyalty_balance = item[:loyalty_balance]
          customer.loyalty_points_available = item[:loyalty_points_available]
          customer.membership_type_name = item[:membership_type_name]
          customer.middle_name = item[:middle_name]
          customer.player_tier_name = item[:player_tier_name]
          customer.player_tier_short_code = item[:player_tier_short_code]
          customer.premium_player = item[:premium_player]
          customer.surname = item[:surname]
          customer.title = item[:title]
          customer.valid_membership = item[:valid_membership]
          customer.date_of_birth = customer_extra_info[:date_of_birth]
          customer.membership_last_issue_date = customer_extra_info[:membership_last_issue_date]
          
          # Create a new customer image
          image_base64 = customer_extra_info[:picture]
          # Check customer picture existed
          if !customer.attachment_id.nil? && customer.attachment_id != 0
            # TODO check image_base64 vs image base64 of existed attachment
          end

          ActiveRecord::Base::transaction do
            _ok = customer.save
            raise ActiveRecord::Rollback, result = false unless _ok
          end
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to customers_url, notice: "Customer was successfully synchronize." }
      format.json { head :no_content }
    end
  end

  def synchronize
    result = true
    customer_data = get_data_customer_by_date()
    respond_to do |format|
      format.html { redirect_to customers_url, notice: "Customer was successfully synchronize." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:age, :card_number, :cashless_balance, :colour, :colour_html, :comp_balance, :comp_status_colour, :comp_status_colour_html, :forename, :freeplay_balance, :gender, :has_online_account, :hide_comp_balance, :is_guest, :loyalty_balance, :loyalty_points_available, :membership_type_name, :middle_name, :number, :player_tier_name, :player_tier_short_code, :premium_player, :surname, :title, :valid_membership, :user_id, :attachment_id, :date_of_birth, :membership_last_issue_date, :nationality, :frame_start_date, :frame_end_date)
    end

    def customer_update_params
      params.require(:customer).permit(:age, :card_number, :cashless_balance, :colour, :colour_html, :comp_balance, :comp_status_colour, :comp_status_colour_html, :forename, :freeplay_balance, :gender, :has_online_account, :hide_comp_balance, :is_guest, :loyalty_balance, :loyalty_points_available, :membership_type_name, :middle_name, :number, :player_tier_name, :player_tier_short_code, :premium_player, :surname, :title, :valid_membership, :user_id, :date_of_birth, :membership_last_issue_date, :nationality, :frame_start_date, :frame_end_date)
    end

  def send_file_list(customers)
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
                   "Gender",
                   "Card number",
                   "premium player",
                   "created_at",
                   "updated_at"], style: header_style

    customers.each do |item|
      language = {}
      sheet.add_row [item.id,
                     item.customer.forename.to_s + " " + item.customer.middle_name.to_s + " " + item.customer.surname.to_s,
                     item.gender,
                     item.card_number,
                     item.premium_player,
                     item.created_at,
                     item.updated_at]
    end

    folder_name = "Customers"
    filename = "Customers_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename

    dir_path = File.dirname(tmp_file_path)
    FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

    book.serialize tmp_file_path
    send_file tmp_file_path, filename: filename
  end
end
