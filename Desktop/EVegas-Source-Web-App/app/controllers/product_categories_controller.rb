class ProductCategoriesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_product_category, only: %i[ show edit update destroy ]

  include CommonModule

  # GET /product_categories or /product_categories.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @product_categories = ProductCategory.order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @search_query = @search_query.strip
      @product_categories = ProductCategory.where("name LIKE ?", "%#{@search_query}%").order('id desc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /product_categories/1 or /product_categories/1.json
  def show
  end

  # GET /product_categories/new
  def new
    @product_category = ProductCategory.new
  end

  # GET /product_categories/1/edit
  def edit
  end

  # POST /product_categories or /product_categories.json
  def create
    @product_category = ProductCategory.new(product_category_params)

    respond_to do |format|
      if @product_category.save
        format.html { redirect_to product_category_url(@product_category), notice: "Product category was successfully created." }
        format.json { render :show, status: :created, location: @product_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_categories/1 or /product_categories/1.json
  def update
    respond_to do |format|
      if @product_category.update(product_category_params)
        format.html { redirect_to product_category_url(@product_category), notice: "Product category was successfully updated." }
        format.json { render :show, status: :ok, location: @product_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_categories/1 or /product_categories/1.json
  def destroy
    @product_category.destroy

    respond_to do |format|
      format.html { redirect_to product_categories_url, notice: "Product category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_category
      @product_category = ProductCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_category_params
      params.require(:product_category).permit(:name, :index_category)
    end
end
