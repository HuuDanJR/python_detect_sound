json.extract! product, :id, :sku, :qrcode, :name, :description, :base_price, :price, :point_price, :product_type, :attachment_id, :product_category_id, :created_at, :updated_at, :index_product
json.url product_url(product, format: :json)
