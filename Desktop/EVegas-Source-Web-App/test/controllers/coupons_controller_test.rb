require 'test_helper'

class CouponsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coupon = coupons(:one)
  end

  test "should get index" do
    get coupons_url
    assert_response :success
  end

  test "should get new" do
    get new_coupon_url
    assert_response :success
  end

  test "should create coupon" do
    assert_difference('Coupon.count') do
      post coupons_url, params: { coupon: { description: @coupon.description, expired: @coupon.expired, issued: @coupon.issued, mb: @coupon.mb, name: @coupon.name, no: @coupon.no, title: @coupon.title } }
    end

    assert_redirected_to coupon_url(Coupon.last)
  end

  test "should show coupon" do
    get coupon_url(@coupon)
    assert_response :success
  end

  test "should get edit" do
    get edit_coupon_url(@coupon)
    assert_response :success
  end

  test "should update coupon" do
    patch coupon_url(@coupon), params: { coupon: { description: @coupon.description, expired: @coupon.expired, issued: @coupon.issued, mb: @coupon.mb, name: @coupon.name, no: @coupon.no, title: @coupon.title } }
    assert_redirected_to coupon_url(@coupon)
  end

  test "should destroy coupon" do
    assert_difference('Coupon.count', -1) do
      delete coupon_url(@coupon)
    end

    assert_redirected_to coupons_url
  end
end
