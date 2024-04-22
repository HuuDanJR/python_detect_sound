require "application_system_test_case"

class DriversTest < ApplicationSystemTestCase
  setup do
    @driver = drivers(:one)
  end

  test "visiting the index" do
    visit drivers_url
    assert_selector "h1", text: "Drivers"
  end

  test "creating a Driver" do
    visit drivers_url
    click_on "New Driver"

    fill_in "Date of birth", with: @driver.date_of_birth
    check "Gender" if @driver.gender
    fill_in "Name", with: @driver.name
    fill_in "Nickname", with: @driver.nickname
    fill_in "Phone", with: @driver.phone
    fill_in "Position", with: @driver.position
    click_on "Create Driver"

    assert_text "Driver was successfully created"
    click_on "Back"
  end

  test "updating a Driver" do
    visit drivers_url
    click_on "Edit", match: :first

    fill_in "Date of birth", with: @driver.date_of_birth
    check "Gender" if @driver.gender
    fill_in "Name", with: @driver.name
    fill_in "Nickname", with: @driver.nickname
    fill_in "Phone", with: @driver.phone
    fill_in "Position", with: @driver.position
    click_on "Update Driver"

    assert_text "Driver was successfully updated"
    click_on "Back"
  end

  test "destroying a Driver" do
    visit drivers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Driver was successfully destroyed"
  end
end
