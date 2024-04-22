class CouponTemplatesController < ApplicationController
  layout 'admin'
  before_action :authorized_user
  before_action :set_coupon_template, only: %i[ show edit update destroy ]
  skip_before_action :authorized_user, :only => [:get_name_coupon]

  # GET /coupon_templates or /coupon_templates.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]

    @coupon_templates = CouponTemplate
                    .select("coupon_templates.*")

    if !is_blank(@search_query)
      @coupon_templates = @coupon_templates.where("coupon_templates.name LIKE ?", "%#{@search_query.strip}%")
    end

    @coupon_templates = @coupon_templates.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])

  end

  # GET /coupon_templates/1 or /coupon_templates/1.json
  def show
  end

  # GET /coupon_templates/new
  def new
    @coupon_template = CouponTemplate.new
    @benefits = Benefit.all.where("status > 0")
  end

  # GET /coupon_templates/1/edit
  def edit
    @benefits = Benefit.all.where("status > 0")
  end

  # POST /coupon_templates or /coupon_templates.json
  def create
    @benefits = Benefit.all.where("status > 0")
    @coupon_template = CouponTemplate.new(coupon_template_params)
    respond_to do |format|
      if @coupon_template.save
        format.html { redirect_to coupon_template_url(@coupon_template), notice: "Coupon template was successfully created." }
        format.json { render :show, status: :created, location: @coupon_template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @coupon_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coupon_templates/1 or /coupon_templates/1.json
  def update
    @benefits = Benefit.all.where("status > 0")
    respond_to do |format|
      if @coupon_template.update(coupon_template_params)
        Coupon.where(coupon_template_id: @coupon_template.id).update_all(name: @coupon_template.name, description: @coupon_template.description, description_ja: @coupon_template.description_ja, description_cn: @coupon_template.description_cn, description_kr: @coupon_template.description_kr)
        format.html { redirect_to coupon_template_url(@coupon_template), notice: "Coupon template was successfully updated." }
        format.json { render :show, status: :ok, location: @coupon_template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @coupon_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupon_templates/1 or /coupon_templates/1.json
  def destroy
    coupons = Coupon.where('coupon_template_id = ?', @coupon_template.id)
    if coupons.length > 0
      coupons.destroy_all
    end

    @coupon_template.destroy

    respond_to do |format|
      format.html { redirect_to coupon_templates_url, notice: "Coupon template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def get_name_coupon
    name_coupon = params[:search]
    unless name_coupon.blank?
      coupon_template = CouponTemplate.find_by("name = ?", name_coupon.strip)
      if coupon_template
        render json: { name: coupon_template.name }
      else
        render json: { name: nil }
      end
    else
      render json: { name: nil }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coupon_template
      @coupon_template = CouponTemplate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coupon_template_params
      params.require(:coupon_template).permit(:name, :description, :benefit_ids, :benefit_totals, :description_ja, :description_kr, :description_cn, :name_ja, :name_kr, :name_cn)
    end
end
