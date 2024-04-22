class CustomerImportsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user

  # GET /customer_imports/new
  def new
    @customer_import = CustomerImport.new
  end

  # POST /customer_imports
  def create
    if params[:customer_import].nil?
      redirect_to :new_customer_import, alert: t(:file_import_not_found)
    else
      @customer_import = CustomerImport.new(params[:customer_import])
      if @customer_import.save
        redirect_to customers_path, notice: t(:file_import_success)
      else
        redirect_to :new_customer_import, alert: t(:error_500_info)
      end
    end
  end
end
