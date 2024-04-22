class ProductImportsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user

  # GET /product_imports/new
  def new
    @product_import = ProductImport.new
  end

  # POST /product_imports
  def create
    if params[:product_import].nil?
      redirect_to :new_product_import, alert: t(:file_import_not_found)
    else
      @product_import = ProductImport.new(params[:product_import])
      if @product_import.save
        redirect_to products_path, notice: t(:file_import_success)
      else
        redirect_to :new_product_import, alert: t(:error_500_info)
      end
    end
  end
end
