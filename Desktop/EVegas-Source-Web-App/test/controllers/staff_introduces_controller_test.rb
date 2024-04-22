require 'test_helper'

class StaffIntroducesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @staff_introduce = staff_introduces(:one)
  end

  test "should get index" do
    get staff_introduces_url
    assert_response :success
  end

  test "should get new" do
    get new_staff_introduce_url
    assert_response :success
  end

  test "should create staff_introduce" do
    assert_difference('StaffIntroduce.count') do
      post staff_introduces_url, params: { staff_introduce: {  } }
    end

    assert_redirected_to staff_introduce_url(StaffIntroduce.last)
  end

  test "should show staff_introduce" do
    get staff_introduce_url(@staff_introduce)
    assert_response :success
  end

  test "should get edit" do
    get edit_staff_introduce_url(@staff_introduce)
    assert_response :success
  end

  test "should update staff_introduce" do
    patch staff_introduce_url(@staff_introduce), params: { staff_introduce: {  } }
    assert_redirected_to staff_introduce_url(@staff_introduce)
  end

  test "should destroy staff_introduce" do
    assert_difference('StaffIntroduce.count', -1) do
      delete staff_introduce_url(@staff_introduce)
    end

    assert_redirected_to staff_introduces_url
  end
end
