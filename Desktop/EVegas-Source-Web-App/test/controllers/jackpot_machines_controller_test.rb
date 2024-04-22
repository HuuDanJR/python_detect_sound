require 'test_helper'

class JackpotMachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jackpot_machine = jackpot_machines(:one)
  end

  test "should get index" do
    get jackpot_machines_url
    assert_response :success
  end

  test "should get new" do
    get new_jackpot_machine_url
    assert_response :success
  end

  test "should create jackpot_machine" do
    assert_difference('JackpotMachine.count') do
      post jackpot_machines_url, params: { jackpot_machine: { jp_date: @jackpot_machine.jp_date, jp_value: @jackpot_machine.jp_value, mc_name: @jackpot_machine.mc_name, mc_number: @jackpot_machine.mc_number } }
    end

    assert_redirected_to jackpot_machine_url(JackpotMachine.last)
  end

  test "should show jackpot_machine" do
    get jackpot_machine_url(@jackpot_machine)
    assert_response :success
  end

  test "should get edit" do
    get edit_jackpot_machine_url(@jackpot_machine)
    assert_response :success
  end

  test "should update jackpot_machine" do
    patch jackpot_machine_url(@jackpot_machine), params: { jackpot_machine: { jp_date: @jackpot_machine.jp_date, jp_value: @jackpot_machine.jp_value, mc_name: @jackpot_machine.mc_name, mc_number: @jackpot_machine.mc_number } }
    assert_redirected_to jackpot_machine_url(@jackpot_machine)
  end

  test "should destroy jackpot_machine" do
    assert_difference('JackpotMachine.count', -1) do
      delete jackpot_machine_url(@jackpot_machine)
    end

    assert_redirected_to jackpot_machines_url
  end
end
