require "application_system_test_case"

class JackpotMachinesTest < ApplicationSystemTestCase
  setup do
    @jackpot_machine = jackpot_machines(:one)
  end

  test "visiting the index" do
    visit jackpot_machines_url
    assert_selector "h1", text: "Jackpot Machines"
  end

  test "creating a Jackpot machine" do
    visit jackpot_machines_url
    click_on "New Jackpot Machine"

    fill_in "Jp date", with: @jackpot_machine.jp_date
    fill_in "Jp value", with: @jackpot_machine.jp_value
    fill_in "Mc name", with: @jackpot_machine.mc_name
    fill_in "Mc number", with: @jackpot_machine.mc_number
    click_on "Create Jackpot machine"

    assert_text "Jackpot machine was successfully created"
    click_on "Back"
  end

  test "updating a Jackpot machine" do
    visit jackpot_machines_url
    click_on "Edit", match: :first

    fill_in "Jp date", with: @jackpot_machine.jp_date
    fill_in "Jp value", with: @jackpot_machine.jp_value
    fill_in "Mc name", with: @jackpot_machine.mc_name
    fill_in "Mc number", with: @jackpot_machine.mc_number
    click_on "Update Jackpot machine"

    assert_text "Jackpot machine was successfully updated"
    click_on "Back"
  end

  test "destroying a Jackpot machine" do
    visit jackpot_machines_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Jackpot machine was successfully destroyed"
  end
end
