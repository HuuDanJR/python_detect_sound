class PromotionCategoriesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_promotion_category, only: %i[ show edit update destroy ]

  include CommonModule
  # GET /promotion_categories or /promotion_categories.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @promotion_categories = PromotionCategory.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @promotion_categories = PromotionCategory.where("name LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /promotion_categories/1 or /promotion_categories/1.json
  def show
  end

  # GET /promotion_categories/new
  def new
    @promotion_category = PromotionCategory.new
  end

  # GET /promotion_categories/1/edit
  def edit
  end

  # POST /promotion_categories or /promotion_categories.json
  def create
    @promotion_category = PromotionCategory.new(promotion_category_params)

    respond_to do |format|
      if @promotion_category.save
        format.html { redirect_to promotion_category_url(@promotion_category), notice: "Promotion category was successfully created." }
        format.json { render :show, status: :created, location: @promotion_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @promotion_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /promotion_categories/1 or /promotion_categories/1.json
  def update
    respond_to do |format|
      if @promotion_category.update(promotion_category_params)
        format.html { redirect_to promotion_category_url(@promotion_category), notice: "Promotion category was successfully updated." }
        format.json { render :show, status: :ok, location: @promotion_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @promotion_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promotion_categories/1 or /promotion_categories/1.json
  def destroy
    @promotion_category.destroy

    respond_to do |format|
      format.html { redirect_to promotion_categories_url, notice: "Promotion category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promotion_category
      @promotion_category = PromotionCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def promotion_category_params
      params.require(:promotion_category).permit(:name)
    end
end
