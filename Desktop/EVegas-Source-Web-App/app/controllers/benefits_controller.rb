class BenefitsController < ApplicationController
  layout 'admin'
  before_action :authorized_user
  before_action :set_benefit, only: %i[ show edit update destroy ]

  include AttachmentModule
  # GET /benefits or /benefits.json
  def index
    @page = params[:page].to_i == 0 ? 1 : params[:page].to_i
    @search = params[:search]
    @benefits = Benefit

    if !is_blank(@search)
      @benefits = @benefits.where("benefits.name LIKE ?", "%#{@search}%")
    end

    @benefits = @benefits.where("benefits.status > 0").order("id ASC").paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /benefits/1 or /benefits/1.json
  def show
  end

  # GET /benefits/new
  def new
    @benefit = Benefit.new
  end

  # GET /benefits/1/edit
  def edit
  end

  # POST /benefits or /benefits.json
  def create
    @benefit = Benefit.new(benefit_params)
    @benefit.attachment_id = -1
    attachment = get_attachment_from_request(params[:benefit][:attachment])
    if !is_blank(attachment)
      attachment.save
      @benefit.attachment_id = attachment.id
    end

    respond_to do |format|  
      if @benefit.save
        format.html { redirect_to benefit_url(@benefit), notice: "Benefit was successfully created." }
        format.json { render :show, status: :created, location: @benefit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @benefit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /benefits/1 or /benefits/1.json
  def update
    attachment = get_attachment_from_request(params[:benefit][:attachment])
    if !is_blank(attachment)
      attachment.save
      @benefit.attachment_id = attachment.id
    end
    respond_to do |format|
      if @benefit.update(benefit_update_params)
        format.html { redirect_to benefit_url(@benefit), notice: "Benefit was successfully updated." }
        format.json { render :show, status: :ok, location: @benefit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @benefit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /benefits/1 or /benefits/1.json
  def destroy
    @benefit.status = 0
    
    respond_to do |format|
      if @benefit.save
        format.html { redirect_to benefits_url, notice: "Benefit was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to benefits_url, notice: "Benefit was failed destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_benefit
      @benefit = Benefit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def benefit_params
      params.require(:benefit).permit(:name, :description, :attachment_id, :name_ja, :description_ja, :name_kr, :description_kr, :name_cn, :description_cn)
    end

    # Only allow a list of trusted parameters through.
    def benefit_update_params
      params.require(:benefit).permit(:name, :description, :name_ja, :description_ja, :name_kr, :description_kr, :name_cn, :description_cn)
    end
end
