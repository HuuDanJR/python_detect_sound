require "application_system_test_case"

class StaffsTest < ApplicationSystemTestCase
  setup do
    @staff = staffs(:one)
  end

  test "visiting the index" do
    visit staffs_url
    assert_selector "h1", text: "Staffs"
  end

  test "creating a Staff" do
    visit staffs_url
    click_on "New Staff"

    fill_in "Code", with: @staff.code
    fill_in "Gender", with: @staff.gender
    fill_in "Name", with: @staff.name
    fill_in "Nick name", with: @staff.nick_name
    fill_in "Position", with: @staff.position
    click_on "Create Staff"

    assert_text "Staff was successfully created"
    click_on "Back"
  end

  test "updating a Staff" do
    visit staffs_url
    click_on "Edit", match: :first

    fill_in "Code", with: @staff.code
    fill_in "Gender", with: @staff.gender
    fill_in "Name", with: @staff.name
    fill_in "Nick name", with: @staff.nick_name
    fill_in "Position", with: @staff.position
    click_on "Update Staff"

    assert_text "Staff was successfully updated"
    click_on "Back"
  end

  test "destroying a Staff" do
    visit staffs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Staff was successfully destroyed"
  end
end
