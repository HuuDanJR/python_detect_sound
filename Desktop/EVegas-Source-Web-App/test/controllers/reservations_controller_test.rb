require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = reservations(:one)
  end

  test "should get index" do
    get reservations_url
    assert_response :success
  end

  test "should get new" do
    get new_reservation_url
    assert_response :success
  end

  test "should create reservation" do
    assert_difference('Reservation.count') do
      post reservations_url, params: { reservation: { address: @reservation.address, arrival_at: @reservation.arrival_at, booking_type: @reservation.booking_type, car_type: @reservation.car_type, customer_id: @reservation.customer_id, customer_note: @reservation.customer_note, distance: @reservation.distance, driver_mobile: @reservation.driver_mobile, driver_name: @reservation.driver_name, drop_off_at: @reservation.drop_off_at, internal_note: @reservation.internal_note, license_plate: @reservation.license_plate, pickup_at: @reservation.pickup_at, price: @reservation.price, reservation_type: @reservation.reservation_type, status: @reservation.status } }
    end

    assert_redirected_to reservation_url(Reservation.last)
  end

  test "should show reservation" do
    get reservation_url(@reservation)
    assert_response :success
  end

  test "should get edit" do
    get edit_reservation_url(@reservation)
    assert_response :success
  end

  test "should update reservation" do
    patch reservation_url(@reservation), params: { reservation: { address: @reservation.address, arrival_at: @reservation.arrival_at, booking_type: @reservation.booking_type, car_type: @reservation.car_type, customer_id: @reservation.customer_id, customer_note: @reservation.customer_note, distance: @reservation.distance, driver_mobile: @reservation.driver_mobile, driver_name: @reservation.driver_name, drop_off_at: @reservation.drop_off_at, internal_note: @reservation.internal_note, license_plate: @reservation.license_plate, pickup_at: @reservation.pickup_at, price: @reservation.price, reservation_type: @reservation.reservation_type, status: @reservation.status } }
    assert_redirected_to reservation_url(@reservation)
  end

  test "should destroy reservation" do
    assert_difference('Reservation.count', -1) do
      delete reservation_url(@reservation)
    end

    assert_redirected_to reservations_url
  end
end
