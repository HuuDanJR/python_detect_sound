require "application_system_test_case"

class MachineReservationsTest < ApplicationSystemTestCase
  setup do
    @machine_reservation = machine_reservations(:one)
  end

  test "visiting the index" do
    visit machine_reservations_url
    assert_selector "h1", text: "Machine Reservations"
  end

  test "creating a Machine reservation" do
    visit machine_reservations_url
    click_on "New Machine Reservation"

    fill_in "Booking type", with: @machine_reservation.booking_type
    fill_in "Customer", with: @machine_reservation.customer_id
    fill_in "Customer note", with: @machine_reservation.customer_note
    fill_in "Ended at", with: @machine_reservation.ended_at
    fill_in "Internal note", with: @machine_reservation.internal_note
    fill_in "Machine name", with: @machine_reservation.machine_name
    fill_in "Machine number", with: @machine_reservation.machine_number
    fill_in "Started at", with: @machine_reservation.started_at
    fill_in "Status", with: @machine_reservation.status
    click_on "Create Machine reservation"

    assert_text "Machine reservation was successfully created"
    click_on "Back"
  end

  test "updating a Machine reservation" do
    visit machine_reservations_url
    click_on "Edit", match: :first

    fill_in "Booking type", with: @machine_reservation.booking_type
    fill_in "Customer", with: @machine_reservation.customer_id
    fill_in "Customer note", with: @machine_reservation.customer_note
    fill_in "Ended at", with: @machine_reservation.ended_at
    fill_in "Internal note", with: @machine_reservation.internal_note
    fill_in "Machine name", with: @machine_reservation.machine_name
    fill_in "Machine number", with: @machine_reservation.machine_number
    fill_in "Started at", with: @machine_reservation.started_at
    fill_in "Status", with: @machine_reservation.status
    click_on "Update Machine reservation"

    assert_text "Machine reservation was successfully updated"
    click_on "Back"
  end

  test "destroying a Machine reservation" do
    visit machine_reservations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Machine reservation was successfully destroyed"
  end
end
