class OfficerCustomersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user

  include CommonModule

  # GET /officer_customers
  # GET /officer_customers.json
  def index
    @officers = Officer.all
    @customers = Customer.all

    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end

    @officer_customers = OfficerCustomer.includes(:officer => [], :customer => []).joins(:officer => [], :customer => []).order("officer_customers.id DESC").paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    
    @search_query = params[:search]
    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @officer_customers = @officer_customers.where("officers.name LIKE ? OR customers.forename LIKE ? OR customers.middle_name LIKE ? OR customers.surname LIKE ?", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%", "%#{@search_query}%")
    end

    @officer = params[:officer]
    if !is_blank(@officer)
      @officer_customers = @officer_customers.where("officer_customers.officer_id = ?", @officer)
    end

    @customer = params[:customer]
    if !is_blank(@customer)
      @officer_customers = @officer_customers.where("officer_customers.customer_id = ?", @customer)
    end
  end

  # EXPORT /officer_customers/export
  def export
    officer_customers = OfficerCustomer.includes(:officer => [], :customer => []).joins(:officer => [], :customer => []).order("officer_customers.created_at DESC")
    
    search_query = params[:search]
    if !is_blank(search_query)
      officer_customers = officer_customers.where("officers.name LIKE ? OR customers.forename LIKE ?", "%#{search_query}%", "%#{search_query}%")
    end

    officer = params[:officer]
    if !is_blank(officer)
      officer_customers = officer_customers.where("officer_customers.officer_id = ?", officer)
    end

    customer = params[:customer]
    if !is_blank(customer)
      officer_customers = officer_customers.where("officer_customers.customer_id = ?", customer)
    end

    send_file_list(officer_customers)
  end

  private

  def send_file_list(officer_customers)
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
                   "officer_id",
                   "officer_name",
                   "customer_id",
                   "customer_name",
                   "created_at",
                   "updated_at"], style: header_style

    officer_customers.each do |item|
      language = {}
      sheet.add_row [item.id,
                     item.officer_id,
                     item.officer.name,
                     item.customer_id,
                     item.customer.forename.to_s + " " + item.customer.middle_name.to_s + " " + item.customer.surname.to_s,
                     item.created_at,
                     item.updated_at]
    end

    folder_name = "officer_customers"
    filename = "officer_customers_list_#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx"
    tmp_file_path = "#{Rails.root}/tmp/#{folder_name}/" + filename

    dir_path = File.dirname(tmp_file_path)
    FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

    book.serialize tmp_file_path
    send_file tmp_file_path, filename: filename
  end
end
