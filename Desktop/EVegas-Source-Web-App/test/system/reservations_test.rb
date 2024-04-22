require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  setup do
    @reservation = reservations(:one)
  end

  test "visiting the index" do
    visit reservations_url
    assert_selector "h1", text: "Reservations"
  end

  test "creating a Reservation" do
    visit reservations_url
    click_on "New Reservation"

    fill_in "Address", with: @reservation.address
    fill_in "Arrival at", with: @reservation.arrival_at
    fill_in "Booking type", with: @reservation.booking_type
    fill_in "Car type", with: @reservation.car_type
    fill_in "Customer", with: @reservation.customer_id
    fill_in "Customer note", with: @reservation.customer_note
    fill_in "Distance", with: @reservation.distance
    fill_in "Driver mobile", with: @reservation.driver_mobile
    fill_in "Driver name", with: @reservation.driver_name
    fill_in "Drop off at", with: @reservation.drop_off_at
    fill_in "Internal note", with: @reservation.internal_note
    fill_in "License plate", with: @reservation.license_plate
    fill_in "Pickup at", with: @reservation.pickup_at
    fill_in "Price", with: @reservation.price
    fill_in "Reservation type", with: @reservation.reservation_type
    fill_in "Status", with: @reservation.status
    click_on "Create Reservation"

    assert_text "Reservation was successfully created"
    click_on "Back"
  end

  test "updating a Reservation" do
    visit reservations_url
    click_on "Edit", match: :first

    fill_in "Address", with: @reservation.address
    fill_in "Arrival at", with: @reservation.arrival_at
    fill_in "Booking type", with: @reservation.booking_type
    fill_in "Car type", with: @reservation.car_type
    fill_in "Customer", with: @reservation.customer_id
    fill_in "Customer note", with: @reservation.customer_note
    fill_in "Distance", with: @reservation.distance
    fill_in "Driver mobile", with: @reservation.driver_mobile
    fill_in "Driver name", with: @reservation.driver_name
    fill_in "Drop off at", with: @reservation.drop_off_at
    fill_in "Internal note", with: @reservation.internal_note
    fill_in "License plate", with: @reservation.license_plate
    fill_in "Pickup at", with: @reservation.pickup_at
    fill_in "Price", with: @reservation.price
    fill_in "Reservation type", with: @reservation.reservation_type
    fill_in "Status", with: @reservation.status
    click_on "Update Reservation"

    assert_text "Reservation was successfully updated"
    click_on "Back"
  end

  test "destroying a Reservation" do
    visit reservations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reservation was successfully destroyed"
  end
end
