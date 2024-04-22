require 'digest'
require 'securerandom'
require "down"

class ProductImport
  include ActiveModel::Model
  require 'roo'

  attr_accessor :file

  include AttachmentModule

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then
      Csv.new(file.path, nil, :ignore)
    when ".xls" then
      Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then
      Roo::Excelx.new(file.path)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_imported_items
    spreadsheet = open_spreadsheet

    @productList = []
    header = spreadsheet.sheet(0).row(1)
    (2..spreadsheet.sheet(0).last_row).map do |i|
      row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
      @productList.push(ProductData.new(row["sku"], row["name"], row["desc"],
                                        row["base_price"], row["price"], row["product_type"], row["attachment"], row["product_category"]))
    end
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def save
    result = true
    imported_items

    @productList.each do |item|
      product = Product.where("sku = ?", "#{item.sku}").first
      if product.nil?
        # Create new a product
        product = Product.new
        product.sku = item.sku
        product.qrcode = SecureRandom.uuid
        product.name = item.name
        product.desc = item.desc
        product.base_price = item.base_price
        product.price = item.price
        product.point_price = item.base_price
        if item.product_type == "Đồ ăn"
          product.product_type = 1
        else
          product.product_type = 2
        end
        product.attachment_id = get_image(item.attachment)
        product.product_category_id = get_product_category(item.product_category)

        if product.attachment_id != 0 && product.product_category_id != 0
          ActiveRecord::Base::transaction do
            _ok = product.save
            raise ActiveRecord::Rollback, result = false unless _ok
          end
        end
      else
        # Update product info
        product.name = item.name
        product.desc = item.desc
        product.base_price = item.base_price
        product.price = item.price
        product.point_price = item.base_price
        if item.product_type == "Đồ ăn"
          product.product_type = 1
        else
          product.product_type = 2
        end
        product.attachment_id = get_image(item.attachment)
        product.product_category_id = get_product_category(item.product_category)

        if product.attachment_id != 0 && product.product_category_id != 0
          ActiveRecord::Base::transaction do
            _ok = product.save
            raise ActiveRecord::Rollback, result = false unless _ok
          end
        end
      end

      if result == false
        return false
      end
    end

    return result
  end

  def get_image(product_attachment)
    id = 0
    if !product_attachment.nil?
      attachments = product_attachment.split(',').map(&:strip)
      if attachments.length > 0
        attachment = save_image(attachments[0])
        if attachment != nil
          ActiveRecord::Base::transaction do
            _ok = create_attachment_file(attachment)
            raise ActiveRecord::Rollback, id = 0 unless _ok
            id = attachment.id
          end
        end
      end
    end
    return id
  end

  def save_image(file_url)
    if file_url.nil?
      return nil
    end

    attachment = Attachment.new
    begin
      tempfile = Down.download(file_url, extension: "jpeg")
      if tempfile.content_type == "text/plain"
        return nil
      end
      file_name = tempfile.original_filename
      attachment.file = Pathname.new(tempfile.path).open
    rescue Exception => e
      return nil
    end

    attachment.category = get_extension_file_upload(attachment.file)
    attachment.name = file_name
    attachment.file_hash = Digest::MD5.hexdigest(attachment.file.read)
    return attachment
  end

  def get_product_category(product_category)
    id = 0
    if !product_category.nil?
      product_category_data = ProductCategory.where("name = ?", "#{product_category}").first
      if product_category_data.nil?
        # Insert a new product category
        new_product_category = ProductCategory.new
        new_product_category.name = product_category
        ActiveRecord::Base::transaction do
          _ok = new_product_category.save
          raise ActiveRecord::Rollback, id = 0 unless _ok
          id = new_product_category.id
        end
      else
        id = product_category_data.id
      end
    end
    return id 
  end
end

class ProductData
  attr_accessor :sku, :name, :desc, :base_price, :price, :product_type, :attachment, :product_category

  def initialize(sku, name, desc, base_price, price, product_type, attachment, product_category)
    @sku = sku
    @name = name
    @desc = desc
    @base_price = base_price
    @price = price
    @product_type = product_type
    @attachment = attachment
    @product_category = product_category
  end
end