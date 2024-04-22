class CustomerFrameDateImportsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user

  # GET /customer_imports/new
  def new
    @customer_frame_date_import = CustomerFrameDateImport.new
  end

  # POST /customer_imports
  def create
    if params[:customer_frame_date_import].nil?
      redirect_to :new_customer_frame_date_import, alert: t(:file_import_not_found)
    else
      @customer_frame_date_import = CustomerFrameDateImport.new(params[:customer_frame_date_import])
      if @customer_frame_date_import.save
        redirect_to customers_path, notice: t(:file_import_success)
      else
        redirect_to :new_customer_frame_date_import, notice: t(:file_import_fail)
      end
    end
  end
end
