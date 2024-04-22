require "application_system_test_case"

class AccommodationsTest < ApplicationSystemTestCase
  setup do
    @accommodation = accommodations(:one)
  end

  test "visiting the index" do
    visit accommodations_url
    assert_selector "h1", text: "Accommodations"
  end

  test "creating a Accommodation" do
    visit accommodations_url
    click_on "New Accommodation"

    fill_in "Date pick", with: @accommodation.date_pick
    fill_in "Name", with: @accommodation.name
    fill_in "Note", with: @accommodation.note
    fill_in "Time pick", with: @accommodation.time_pick
    click_on "Create Accommodation"

    assert_text "Accommodation was successfully created"
    click_on "Back"
  end

  test "updating a Accommodation" do
    visit accommodations_url
    click_on "Edit", match: :first

    fill_in "Date pick", with: @accommodation.date_pick
    fill_in "Name", with: @accommodation.name
    fill_in "Note", with: @accommodation.note
    fill_in "Time pick", with: @accommodation.time_pick
    click_on "Update Accommodation"

    assert_text "Accommodation was successfully updated"
    click_on "Back"
  end

  test "destroying a Accommodation" do
    visit accommodations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Accommodation was successfully destroyed"
  end
end
