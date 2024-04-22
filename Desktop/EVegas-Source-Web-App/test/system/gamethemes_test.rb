require "application_system_test_case"

class GamethemesTest < ApplicationSystemTestCase
  setup do
    @gametheme = gamethemes(:one)
  end

  test "visiting the index" do
    visit gamethemes_url
    assert_selector "h1", text: "Gamethemes"
  end

  test "creating a Gametheme" do
    visit gamethemes_url
    click_on "New Gametheme"

    fill_in "Game type", with: @gametheme.game_type_id
    fill_in "Name", with: @gametheme.name
    click_on "Create Gametheme"

    assert_text "Gametheme was successfully created"
    click_on "Back"
  end

  test "updating a Gametheme" do
    visit gamethemes_url
    click_on "Edit", match: :first

    fill_in "Game type", with: @gametheme.game_type_id
    fill_in "Name", with: @gametheme.name
    click_on "Update Gametheme"

    assert_text "Gametheme was successfully updated"
    click_on "Back"
  end

  test "destroying a Gametheme" do
    visit gamethemes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gametheme was successfully destroyed"
  end
end
