require 'test_helper'

class JackpotGameTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jackpot_game_type = jackpot_game_types(:one)
  end

  test "should get index" do
    get jackpot_game_types_url
    assert_response :success
  end

  test "should get new" do
    get new_jackpot_game_type_url
    assert_response :success
  end

  test "should create jackpot_game_type" do
    assert_difference('JackpotGameType.count') do
      post jackpot_game_types_url, params: { jackpot_game_type: { name: @jackpot_game_type.name } }
    end

    assert_redirected_to jackpot_game_type_url(JackpotGameType.last)
  end

  test "should show jackpot_game_type" do
    get jackpot_game_type_url(@jackpot_game_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_jackpot_game_type_url(@jackpot_game_type)
    assert_response :success
  end

  test "should update jackpot_game_type" do
    patch jackpot_game_type_url(@jackpot_game_type), params: { jackpot_game_type: { name: @jackpot_game_type.name } }
    assert_redirected_to jackpot_game_type_url(@jackpot_game_type)
  end

  test "should destroy jackpot_game_type" do
    assert_difference('JackpotGameType.count', -1) do
      delete jackpot_game_type_url(@jackpot_game_type)
    end

    assert_redirected_to jackpot_game_types_url
  end
end
