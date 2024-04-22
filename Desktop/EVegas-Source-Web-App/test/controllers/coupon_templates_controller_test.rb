require 'test_helper'

class CouponTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coupon_template = coupon_templates(:one)
  end

  test "should get index" do
    get coupon_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_coupon_template_url
    assert_response :success
  end

  test "should create coupon_template" do
    assert_difference('CouponTemplate.count') do
      post coupon_templates_url, params: { coupon_template: { benefit_ids: @coupon_template.benefit_ids, description: @coupon_template.description, name: @coupon_template.name } }
    end

    assert_redirected_to coupon_template_url(CouponTemplate.last)
  end

  test "should show coupon_template" do
    get coupon_template_url(@coupon_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_coupon_template_url(@coupon_template)
    assert_response :success
  end

  test "should update coupon_template" do
    patch coupon_template_url(@coupon_template), params: { coupon_template: { benefit_ids: @coupon_template.benefit_ids, description: @coupon_template.description, name: @coupon_template.name } }
    assert_redirected_to coupon_template_url(@coupon_template)
  end

  test "should destroy coupon_template" do
    assert_difference('CouponTemplate.count', -1) do
      delete coupon_template_url(@coupon_template)
    end

    assert_redirected_to coupon_templates_url
  end
end
