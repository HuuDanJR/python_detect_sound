require 'test_helper'

class PromotionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @promotion = promotions(:one)
  end

  test "should get index" do
    get promotions_url
    assert_response :success
  end

  test "should get new" do
    get new_promotion_url
    assert_response :success
  end

  test "should create promotion" do
    assert_difference('Promotion.count') do
      post promotions_url, params: { promotion: { attachment_id: @promotion.attachment_id, day_of_month: @promotion.day_of_month, day_of_season: @promotion.day_of_season, day_of_week: @promotion.day_of_week, game_type: @promotion.game_type, issue_date: @promotion.issue_date, name: @promotion.name, prize: @promotion.prize, promotion_category_id: @promotion.promotion_category_id, remark: @promotion.remark, status: @promotion.status, terms: @promotion.terms, time: @promotion.time } }
    end

    assert_redirected_to promotion_url(Promotion.last)
  end

  test "should show promotion" do
    get promotion_url(@promotion)
    assert_response :success
  end

  test "should get edit" do
    get edit_promotion_url(@promotion)
    assert_response :success
  end

  test "should update promotion" do
    patch promotion_url(@promotion), params: { promotion: { attachment_id: @promotion.attachment_id, day_of_month: @promotion.day_of_month, day_of_season: @promotion.day_of_season, day_of_week: @promotion.day_of_week, game_type: @promotion.game_type, issue_date: @promotion.issue_date, name: @promotion.name, prize: @promotion.prize, promotion_category_id: @promotion.promotion_category_id, remark: @promotion.remark, status: @promotion.status, terms: @promotion.terms, time: @promotion.time } }
    assert_redirected_to promotion_url(@promotion)
  end

  test "should destroy promotion" do
    assert_difference('Promotion.count', -1) do
      delete promotion_url(@promotion)
    end

    assert_redirected_to promotions_url
  end
end
