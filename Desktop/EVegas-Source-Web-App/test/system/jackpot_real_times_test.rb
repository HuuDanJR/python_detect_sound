require "application_system_test_case"

class JackpotRealTimesTest < ApplicationSystemTestCase
  setup do
    @jackpot_real_time = jackpot_real_times(:one)
  end

  test "visiting the index" do
    visit jackpot_real_times_url
    assert_selector "h1", text: "Jackpot Real Times"
  end

  test "creating a Jackpot real time" do
    visit jackpot_real_times_url
    click_on "New Jackpot Real Time"

    fill_in "Data", with: @jackpot_real_time.data
    click_on "Create Jackpot real time"

    assert_text "Jackpot real time was successfully created"
    click_on "Back"
  end

  test "updating a Jackpot real time" do
    visit jackpot_real_times_url
    click_on "Edit", match: :first

    fill_in "Data", with: @jackpot_real_time.data
    click_on "Update Jackpot real time"

    assert_text "Jackpot real time was successfully updated"
    click_on "Back"
  end

  test "destroying a Jackpot real time" do
    visit jackpot_real_times_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Jackpot real time was successfully destroyed"
  end
end
