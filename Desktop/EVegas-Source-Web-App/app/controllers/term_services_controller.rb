class TermServicesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_term_service, only: %i[ show edit update destroy ]

  include AttachmentModule

  # GET /term_services or /term_services.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @term_services = TermService.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /term_services/1 or /term_services/1.json
  def show
  end

  # GET /term_services/new
  def new
    @term_service = TermService.new
  end

  # GET /term_services/1/edit
  def edit
  end

  # POST /term_services or /term_services.json
  def create
    result = true
    @term_service = TermService.new(term_service_params)

    respond_to do |format|
      attachment = get_attachment_from_request(params[:term_service][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @term_service.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @term_service.errors, status: :unprocessable_entity }
        end
      end
      
      if @term_service.save
        format.html { redirect_to term_service_url(@term_service), notice: "Term service was successfully created." }
        format.json { render :show, status: :created, location: @term_service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @term_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /term_services/1 or /term_services/1.json
  def update
    result = true
    respond_to do |format|
      attachment = get_attachment_from_request(params[:term_service][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @term_service.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @term_service.errors, status: :unprocessable_entity }
        end
      end
      puts @term_service.to_json
      if @term_service.update(term_service_params)
        format.html { redirect_to term_service_url(@term_service), notice: "Term service was successfully updated." }
        format.json { render :show, status: :ok, location: @term_service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @term_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /term_services/1 or /term_services/1.json
  def destroy
    @term_service.destroy

    respond_to do |format|
      format.html { redirect_to term_services_url, notice: "Term service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_term_service
      @term_service = TermService.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def term_service_params
      params.require(:term_service).permit(:name, :content, :index)
    end
end
