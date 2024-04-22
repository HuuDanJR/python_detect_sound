json.extract! coupon, :id, :name, :title, :description, :mb, :no, :issued, :expired, :created_at, :updated_at, :time_start, :description_ja, :description_kr, :description_cn, :serial_no, :coupon_template_id, :note
json.url coupon_url(coupon, format: :json)
