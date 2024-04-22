require "application_system_test_case"

class CustomersTest < ApplicationSystemTestCase
  setup do
    @customer = customers(:one)
  end

  test "visiting the index" do
    visit customers_url
    assert_selector "h1", text: "Customers"
  end

  test "creating a Customer" do
    visit customers_url
    click_on "New Customer"

    fill_in "Age", with: @customer.age
    fill_in "Card number", with: @customer.card_number
    fill_in "Cashless balance", with: @customer.cashless_balance
    fill_in "Colour", with: @customer.colour
    fill_in "Colour html", with: @customer.colour_html
    fill_in "Comp balance", with: @customer.comp_balance
    fill_in "Comp status colour", with: @customer.comp_status_colour
    fill_in "Comp status colour html", with: @customer.comp_status_colour_html
    fill_in "Forename", with: @customer.forename
    fill_in "Freeplay balance", with: @customer.freeplay_balance
    fill_in "Gender", with: @customer.gender
    check "Has online account" if @customer.has_online_account
    check "Hide comp balance" if @customer.hide_comp_balance
    check "Is guest" if @customer.is_guest
    fill_in "Loyalty balance", with: @customer.loyalty_balance
    fill_in "Loyalty points available", with: @customer.loyalty_points_available
    fill_in "Membership type name", with: @customer.membership_type_name
    fill_in "Middle name", with: @customer.middle_name
    fill_in "Number", with: @customer.number
    fill_in "Player tier name", with: @customer.player_tier_name
    fill_in "Player tier short code", with: @customer.player_tier_short_code
    check "Premium player" if @customer.premium_player
    fill_in "Surname", with: @customer.surname
    fill_in "Title", with: @customer.title
    check "Valid membership" if @customer.valid_membership
    click_on "Create Customer"

    assert_text "Customer was successfully created"
    click_on "Back"
  end

  test "updating a Customer" do
    visit customers_url
    click_on "Edit", match: :first

    fill_in "Age", with: @customer.age
    fill_in "Card number", with: @customer.card_number
    fill_in "Cashless balance", with: @customer.cashless_balance
    fill_in "Colour", with: @customer.colour
    fill_in "Colour html", with: @customer.colour_html
    fill_in "Comp balance", with: @customer.comp_balance
    fill_in "Comp status colour", with: @customer.comp_status_colour
    fill_in "Comp status colour html", with: @customer.comp_status_colour_html
    fill_in "Forename", with: @customer.forename
    fill_in "Freeplay balance", with: @customer.freeplay_balance
    fill_in "Gender", with: @customer.gender
    check "Has online account" if @customer.has_online_account
    check "Hide comp balance" if @customer.hide_comp_balance
    check "Is guest" if @customer.is_guest
    fill_in "Loyalty balance", with: @customer.loyalty_balance
    fill_in "Loyalty points available", with: @customer.loyalty_points_available
    fill_in "Membership type name", with: @customer.membership_type_name
    fill_in "Middle name", with: @customer.middle_name
    fill_in "Number", with: @customer.number
    fill_in "Player tier name", with: @customer.player_tier_name
    fill_in "Player tier short code", with: @customer.player_tier_short_code
    check "Premium player" if @customer.premium_player
    fill_in "Surname", with: @customer.surname
    fill_in "Title", with: @customer.title
    check "Valid membership" if @customer.valid_membership
    click_on "Update Customer"

    assert_text "Customer was successfully updated"
    click_on "Back"
  end

  test "destroying a Customer" do
    visit customers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Customer was successfully destroyed"
  end
end
