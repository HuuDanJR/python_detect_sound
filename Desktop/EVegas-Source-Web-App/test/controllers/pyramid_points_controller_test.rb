require 'test_helper'

class PyramidPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pyramid_point = pyramid_points(:one)
  end

  test "should get index" do
    get pyramid_points_url
    assert_response :success
  end

  test "should get new" do
    get new_pyramid_point_url
    assert_response :success
  end

  test "should create pyramid_point" do
    assert_difference('PyramidPoint.count') do
      post pyramid_points_url, params: { pyramid_point: { max_point: @pyramid_point.max_point, min_point: @pyramid_point.min_point, prize: @pyramid_point.prize } }
    end

    assert_redirected_to pyramid_point_url(PyramidPoint.last)
  end

  test "should show pyramid_point" do
    get pyramid_point_url(@pyramid_point)
    assert_response :success
  end

  test "should get edit" do
    get edit_pyramid_point_url(@pyramid_point)
    assert_response :success
  end

  test "should update pyramid_point" do
    patch pyramid_point_url(@pyramid_point), params: { pyramid_point: { max_point: @pyramid_point.max_point, min_point: @pyramid_point.min_point, prize: @pyramid_point.prize } }
    assert_redirected_to pyramid_point_url(@pyramid_point)
  end

  test "should destroy pyramid_point" do
    assert_difference('PyramidPoint.count', -1) do
      delete pyramid_point_url(@pyramid_point)
    end

    assert_redirected_to pyramid_points_url
  end
end
