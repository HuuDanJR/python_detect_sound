require 'test_helper'

class MachineReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @machine_reservation = machine_reservations(:one)
  end

  test "should get index" do
    get machine_reservations_url
    assert_response :success
  end

  test "should get new" do
    get new_machine_reservation_url
    assert_response :success
  end

  test "should create machine_reservation" do
    assert_difference('MachineReservation.count') do
      post machine_reservations_url, params: { machine_reservation: { booking_type: @machine_reservation.booking_type, customer_id: @machine_reservation.customer_id, customer_note: @machine_reservation.customer_note, ended_at: @machine_reservation.ended_at, internal_note: @machine_reservation.internal_note, machine_name: @machine_reservation.machine_name, machine_number: @machine_reservation.machine_number, started_at: @machine_reservation.started_at, status: @machine_reservation.status } }
    end

    assert_redirected_to machine_reservation_url(MachineReservation.last)
  end

  test "should show machine_reservation" do
    get machine_reservation_url(@machine_reservation)
    assert_response :success
  end

  test "should get edit" do
    get edit_machine_reservation_url(@machine_reservation)
    assert_response :success
  end

  test "should update machine_reservation" do
    patch machine_reservation_url(@machine_reservation), params: { machine_reservation: { booking_type: @machine_reservation.booking_type, customer_id: @machine_reservation.customer_id, customer_note: @machine_reservation.customer_note, ended_at: @machine_reservation.ended_at, internal_note: @machine_reservation.internal_note, machine_name: @machine_reservation.machine_name, machine_number: @machine_reservation.machine_number, started_at: @machine_reservation.started_at, status: @machine_reservation.status } }
    assert_redirected_to machine_reservation_url(@machine_reservation)
  end

  test "should destroy machine_reservation" do
    assert_difference('MachineReservation.count', -1) do
      delete machine_reservation_url(@machine_reservation)
    end

    assert_redirected_to machine_reservations_url
  end
end
