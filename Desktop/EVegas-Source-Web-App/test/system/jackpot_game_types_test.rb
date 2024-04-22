require "application_system_test_case"

class JackpotGameTypesTest < ApplicationSystemTestCase
  setup do
    @jackpot_game_type = jackpot_game_types(:one)
  end

  test "visiting the index" do
    visit jackpot_game_types_url
    assert_selector "h1", text: "Jackpot Game Types"
  end

  test "creating a Jackpot game type" do
    visit jackpot_game_types_url
    click_on "New Jackpot Game Type"

    fill_in "Name", with: @jackpot_game_type.name
    click_on "Create Jackpot game type"

    assert_text "Jackpot game type was successfully created"
    click_on "Back"
  end

  test "updating a Jackpot game type" do
    visit jackpot_game_types_url
    click_on "Edit", match: :first

    fill_in "Name", with: @jackpot_game_type.name
    click_on "Update Jackpot game type"

    assert_text "Jackpot game type was successfully updated"
    click_on "Back"
  end

  test "destroying a Jackpot game type" do
    visit jackpot_game_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Jackpot game type was successfully destroyed"
  end
end
