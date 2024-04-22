json.extract! reservation, :id, :customer_id, :address, :pickup_at, :customer_note, :booking_type, :reservation_type, :driver_name, :driver_mobile, :car_type, :license_plate, :arrival_at, :internal_note, :price, :distance, :drop_off_at, :status, :created_at, :updated_at, :note_confirm, :note_cancel, :note_finish
json.url reservation_url(reservation, format: :json)
