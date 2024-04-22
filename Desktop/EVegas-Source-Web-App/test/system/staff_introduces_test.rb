require "application_system_test_case"

class StaffIntroducesTest < ApplicationSystemTestCase
  setup do
    @staff_introduce = staff_introduces(:one)
  end

  test "visiting the index" do
    visit staff_introduces_url
    assert_selector "h1", text: "Staff Introduces"
  end

  test "creating a Staff introduce" do
    visit staff_introduces_url
    click_on "New Staff Introduce"

    click_on "Create Staff introduce"

    assert_text "Staff introduce was successfully created"
    click_on "Back"
  end

  test "updating a Staff introduce" do
    visit staff_introduces_url
    click_on "Edit", match: :first

    click_on "Update Staff introduce"

    assert_text "Staff introduce was successfully updated"
    click_on "Back"
  end

  test "destroying a Staff introduce" do
    visit staff_introduces_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Staff introduce was successfully destroyed"
  end
end
