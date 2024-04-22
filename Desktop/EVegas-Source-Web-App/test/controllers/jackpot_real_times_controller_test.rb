require 'test_helper'

class JackpotRealTimesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jackpot_real_time = jackpot_real_times(:one)
  end

  test "should get index" do
    get jackpot_real_times_url
    assert_response :success
  end

  test "should get new" do
    get new_jackpot_real_time_url
    assert_response :success
  end

  test "should create jackpot_real_time" do
    assert_difference('JackpotRealTime.count') do
      post jackpot_real_times_url, params: { jackpot_real_time: { data: @jackpot_real_time.data } }
    end

    assert_redirected_to jackpot_real_time_url(JackpotRealTime.last)
  end

  test "should show jackpot_real_time" do
    get jackpot_real_time_url(@jackpot_real_time)
    assert_response :success
  end

  test "should get edit" do
    get edit_jackpot_real_time_url(@jackpot_real_time)
    assert_response :success
  end

  test "should update jackpot_real_time" do
    patch jackpot_real_time_url(@jackpot_real_time), params: { jackpot_real_time: { data: @jackpot_real_time.data } }
    assert_redirected_to jackpot_real_time_url(@jackpot_real_time)
  end

  test "should destroy jackpot_real_time" do
    assert_difference('JackpotRealTime.count', -1) do
      delete jackpot_real_time_url(@jackpot_real_time)
    end

    assert_redirected_to jackpot_real_times_url
  end
end
