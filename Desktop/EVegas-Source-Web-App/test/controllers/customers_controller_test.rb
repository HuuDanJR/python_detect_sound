require 'test_helper'

class CustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer = customers(:one)
  end

  test "should get index" do
    get customers_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_url
    assert_response :success
  end

  test "should create customer" do
    assert_difference('Customer.count') do
      post customers_url, params: { customer: { age: @customer.age, card_number: @customer.card_number, cashless_balance: @customer.cashless_balance, colour: @customer.colour, colour_html: @customer.colour_html, comp_balance: @customer.comp_balance, comp_status_colour: @customer.comp_status_colour, comp_status_colour_html: @customer.comp_status_colour_html, forename: @customer.forename, freeplay_balance: @customer.freeplay_balance, gender: @customer.gender, has_online_account: @customer.has_online_account, hide_comp_balance: @customer.hide_comp_balance, is_guest: @customer.is_guest, loyalty_balance: @customer.loyalty_balance, loyalty_points_available: @customer.loyalty_points_available, membership_type_name: @customer.membership_type_name, middle_name: @customer.middle_name, number: @customer.number, player_tier_name: @customer.player_tier_name, player_tier_short_code: @customer.player_tier_short_code, premium_player: @customer.premium_player, surname: @customer.surname, title: @customer.title, valid_membership: @customer.valid_membership } }
    end

    assert_redirected_to customer_url(Customer.last)
  end

  test "should show customer" do
    get customer_url(@customer)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_url(@customer)
    assert_response :success
  end

  test "should update customer" do
    patch customer_url(@customer), params: { customer: { age: @customer.age, card_number: @customer.card_number, cashless_balance: @customer.cashless_balance, colour: @customer.colour, colour_html: @customer.colour_html, comp_balance: @customer.comp_balance, comp_status_colour: @customer.comp_status_colour, comp_status_colour_html: @customer.comp_status_colour_html, forename: @customer.forename, freeplay_balance: @customer.freeplay_balance, gender: @customer.gender, has_online_account: @customer.has_online_account, hide_comp_balance: @customer.hide_comp_balance, is_guest: @customer.is_guest, loyalty_balance: @customer.loyalty_balance, loyalty_points_available: @customer.loyalty_points_available, membership_type_name: @customer.membership_type_name, middle_name: @customer.middle_name, number: @customer.number, player_tier_name: @customer.player_tier_name, player_tier_short_code: @customer.player_tier_short_code, premium_player: @customer.premium_player, surname: @customer.surname, title: @customer.title, valid_membership: @customer.valid_membership } }
    assert_redirected_to customer_url(@customer)
  end

  test "should destroy customer" do
    assert_difference('Customer.count', -1) do
      delete customer_url(@customer)
    end

    assert_redirected_to customers_url
  end
end
