class ProductsController < ApplicationController
  require "rqrcode"
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_product, only: %i[ show edit update destroy ]

  include CommonModule
  include AttachmentModule
  # GET /products or /products.json
  def index
    @product_categories = ProductCategory.all
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    @products = Product.includes(:product_category => []).joins(:product_category => [])
    @productCate = params[:category]
    if !is_blank(@productCate)
      @products = @products.where("products.product_category_id = ?", @productCate)
    end

    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @products = @products.where("products.name LIKE ?", "%#{@search_query}%")
    end
    @products = @products.order('products.index_product asc').paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
  end

  # GET /products/1 or /products/1.json
  def show
    @imageQrcode = RQRCode::QRCode.new(@product.qrcode).as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    )
    @customer_level = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CUSTOMER_LEVEL').first().setting_value)
    @beverage_type_config = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CONFIG').first().setting_value)['beverage_type']
  end

  # GET /products/new
  def new
    @product = Product.new
    @product_categories = ProductCategory.all
    @imageQrcode = ""
    @customer_level = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CUSTOMER_LEVEL').first().setting_value)
    @beverage_type_config = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CONFIG').first().setting_value)['beverage_type']
  end

  # GET /products/1/edit
  def edit
    @product_categories = ProductCategory.all
    @imageQrcode = RQRCode::QRCode.new(@product.qrcode).as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    )
    @customer_level = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CUSTOMER_LEVEL').first().setting_value)
    @beverage_type_config = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CONFIG').first().setting_value)['beverage_type']
  end

  # POST /products or /products.json
  def create
    result = true
    @customer_level = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CUSTOMER_LEVEL').first().setting_value)
    @beverage_type_config = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CONFIG').first().setting_value)['beverage_type']
    @product = Product.new(product_params)
    @product.qrcode = SecureRandom.uuid

    respond_to do |format|
      attachment = get_attachment_from_request(params[:product][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @product.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end

      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    result = true
    @customer_level = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CUSTOMER_LEVEL').first().setting_value)
    @beverage_type_config = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CONFIG').first().setting_value)
    respond_to do |format|
      attachment = get_attachment_from_request(params[:product][:attachment])
      if attachment != nil
        ActiveRecord::Base::transaction do
          _ok = create_attachment_file(attachment)
          if _ok
            @product.attachment_id = attachment.id
          end
          raise ActiveRecord::Rollback, result = false unless _ok
        end
        if result == false
          format.html { render :edit }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
      if @product.update(product_update_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:sku, :name, :description, :base_price, :price, :point_price, :product_type, :attachment_id, :product_category_id, :customer_level, :beverage_type, :is_hide, :index_product)
    end

    def product_update_params
      params.require(:product).permit(:sku, :name, :description, :base_price, :price, :point_price, :product_type, :customer_level, :beverage_type, :is_hide, :product_category_id, :index_product)
    end

end
