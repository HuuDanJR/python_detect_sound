json.extract! machine_reservation, :id, :customer_id, :machine_number, :machine_name, :started_at, :ended_at, :customer_note, :booking_type, :internal_note, :status, :created_at, :updated_at, :zone, :results_play, :approved_by, :updated_by
json.url machine_reservation_url(machine_reservation, format: :json)
