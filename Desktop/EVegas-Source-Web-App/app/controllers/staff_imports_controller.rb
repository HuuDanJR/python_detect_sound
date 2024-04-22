class StaffImportsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user

  # GET /staff_imports/new
  def new
    @staff_import = StaffImport.new
  end

  # POST /staff_imports
  def create
    if params[:staff_import].nil?
      redirect_to :new_staff_import, alert: t(:file_import_not_found)
    else
      @staff_import = StaffImport.new(params[:staff_import])
      if @staff_import.save
        redirect_to staffs_path, notice: t(:file_import_success)
      else
        redirect_to :new_staff_import, alert: t(:error_500_info)
      end
    end
  end
end
