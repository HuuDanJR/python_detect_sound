class HomeController < ApplicationController
  require "rqrcode"
  include CommonModule

  def index
    user_customers = User.select('users.id, users.language').joins(:customer => [], :devices => []).where('users.id in (402,398)').order('devices.id desc').uniq
  end

  def product
    @product_categories = ProductCategory.all
    settings = Setting.where('setting_key = ?', 'PRODUCT_CONFIG').first().setting_value
    settingJson = JSON.parse(settings)
    @customer_level = JSON.parse(Setting.where('setting_key = ?', 'PRODUCT_CUSTOMER_LEVEL').first().setting_value)

    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    @products = Product.includes(:product_category => []).joins(:product_category => [])

    
    @product_types = settingJson['product_type']
    
    @productType = params[:product_type]
    if !is_blank(@productType)
      @products = @products.where("products.product_type = ?", @productType)
    end
    
    @productCate = params[:category]
    if !is_blank(@productCate)
      @products = @products.where("products.product_category_id = ?", @productCate)
    end

    if !is_blank(@search_query)
      @search_query = @search_query.strip
      @products = @products.where("products.name LIKE ?", "%#{@search_query}%")
    end
    
    @customer_levels = params[:customer_level]
    if !is_blank(@customer_levels)
      @products = @products.where("products.customer_level LIKE ?",  "%#{@customer_levels}%")
    end

    @products = @products.paginate(page: @page, :per_page => 30)
    @listQrcode = []
    @products.each do |item|
      @listQrcode.push(RQRCode::QRCode.new(item.qrcode).as_svg(
        color: "000",
        shape_rendering: "crispEdges",
        module_size: 2,
        standalone: true,
        use_path: true
      ))
    end
    
  end

  def privacy
    
  end

  def staff
    
  end

  def staff_introduce
    staff = Staff.where('code = ?', params[:code]).first
    if !staff.nil?
      staff_introduce = StaffIntroduce.new
      staff_introduce.staff_id = staff.id
      ActiveRecord::Base::transaction do
        if staff_introduce.save
          render json: staff_introduce
        else
          render json: nil
          raise ActiveRecord::Rollback
        end
      end
    end
  end

end
