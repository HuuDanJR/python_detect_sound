require "application_system_test_case"

class SpasTest < ApplicationSystemTestCase
  setup do
    @spa = spas(:one)
  end

  test "visiting the index" do
    visit spas_url
    assert_selector "h1", text: "Spas"
  end

  test "creating a Spa" do
    visit spas_url
    click_on "New Spa"

    fill_in "Date pick", with: @spa.date_pick
    fill_in "Name", with: @spa.name
    fill_in "Note", with: @spa.note
    fill_in "Time pick", with: @spa.time_pick
    click_on "Create Spa"

    assert_text "Spa was successfully created"
    click_on "Back"
  end

  test "updating a Spa" do
    visit spas_url
    click_on "Edit", match: :first

    fill_in "Date pick", with: @spa.date_pick
    fill_in "Name", with: @spa.name
    fill_in "Note", with: @spa.note
    fill_in "Time pick", with: @spa.time_pick
    click_on "Update Spa"

    assert_text "Spa was successfully updated"
    click_on "Back"
  end

  test "destroying a Spa" do
    visit spas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Spa was successfully destroyed"
  end
end
