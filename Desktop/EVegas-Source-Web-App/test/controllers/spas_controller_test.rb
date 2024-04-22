require 'test_helper'

class SpasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @spa = spas(:one)
  end

  test "should get index" do
    get spas_url
    assert_response :success
  end

  test "should get new" do
    get new_spa_url
    assert_response :success
  end

  test "should create spa" do
    assert_difference('Spa.count') do
      post spas_url, params: { spa: { date_pick: @spa.date_pick, name: @spa.name, note: @spa.note, time_pick: @spa.time_pick } }
    end

    assert_redirected_to spa_url(Spa.last)
  end

  test "should show spa" do
    get spa_url(@spa)
    assert_response :success
  end

  test "should get edit" do
    get edit_spa_url(@spa)
    assert_response :success
  end

  test "should update spa" do
    patch spa_url(@spa), params: { spa: { date_pick: @spa.date_pick, name: @spa.name, note: @spa.note, time_pick: @spa.time_pick } }
    assert_redirected_to spa_url(@spa)
  end

  test "should destroy spa" do
    assert_difference('Spa.count', -1) do
      delete spa_url(@spa)
    end

    assert_redirected_to spas_url
  end
end
