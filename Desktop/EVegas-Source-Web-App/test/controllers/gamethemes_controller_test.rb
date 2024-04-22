require 'test_helper'

class GamethemesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gametheme = gamethemes(:one)
  end

  test "should get index" do
    get gamethemes_url
    assert_response :success
  end

  test "should get new" do
    get new_gametheme_url
    assert_response :success
  end

  test "should create gametheme" do
    assert_difference('Gametheme.count') do
      post gamethemes_url, params: { gametheme: { game_type_id: @gametheme.game_type_id, name: @gametheme.name } }
    end

    assert_redirected_to gametheme_url(Gametheme.last)
  end

  test "should show gametheme" do
    get gametheme_url(@gametheme)
    assert_response :success
  end

  test "should get edit" do
    get edit_gametheme_url(@gametheme)
    assert_response :success
  end

  test "should update gametheme" do
    patch gametheme_url(@gametheme), params: { gametheme: { game_type_id: @gametheme.game_type_id, name: @gametheme.name } }
    assert_redirected_to gametheme_url(@gametheme)
  end

  test "should destroy gametheme" do
    assert_difference('Gametheme.count', -1) do
      delete gametheme_url(@gametheme)
    end

    assert_redirected_to gamethemes_url
  end
end
