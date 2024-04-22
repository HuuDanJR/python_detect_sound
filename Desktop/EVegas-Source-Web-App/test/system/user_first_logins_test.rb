require "application_system_test_case"

class UserFirstLoginsTest < ApplicationSystemTestCase
  setup do
    @user_first_login = user_first_logins(:one)
  end

  test "visiting the index" do
    visit user_first_logins_url
    assert_selector "h1", text: "User First Logins"
  end

  test "creating a User first login" do
    visit user_first_logins_url
    click_on "New User First Login"

    click_on "Create User first login"

    assert_text "User first login was successfully created"
    click_on "Back"
  end

  test "updating a User first login" do
    visit user_first_logins_url
    click_on "Edit", match: :first

    click_on "Update User first login"

    assert_text "User first login was successfully updated"
    click_on "Back"
  end

  test "destroying a User first login" do
    visit user_first_logins_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User first login was successfully destroyed"
  end
end
