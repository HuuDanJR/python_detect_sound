require 'test_helper'

class PromotionCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @promotion_category = promotion_categories(:one)
  end

  test "should get index" do
    get promotion_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_promotion_category_url
    assert_response :success
  end

  test "should create promotion_category" do
    assert_difference('PromotionCategory.count') do
      post promotion_categories_url, params: { promotion_category: { name: @promotion_category.name } }
    end

    assert_redirected_to promotion_category_url(PromotionCategory.last)
  end

  test "should show promotion_category" do
    get promotion_category_url(@promotion_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_promotion_category_url(@promotion_category)
    assert_response :success
  end

  test "should update promotion_category" do
    patch promotion_category_url(@promotion_category), params: { promotion_category: { name: @promotion_category.name } }
    assert_redirected_to promotion_category_url(@promotion_category)
  end

  test "should destroy promotion_category" do
    assert_difference('PromotionCategory.count', -1) do
      delete promotion_category_url(@promotion_category)
    end

    assert_redirected_to promotion_categories_url
  end
end
