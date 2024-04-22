require "application_system_test_case"

class IntroductionsTest < ApplicationSystemTestCase
  setup do
    @introduction = introductions(:one)
  end

  test "visiting the index" do
    visit introductions_url
    assert_selector "h1", text: "Introductions"
  end

  test "creating a Introduction" do
    visit introductions_url
    click_on "New Introduction"

    fill_in "Description", with: @introduction.description
    fill_in "Intro index", with: @introduction.intro_index
    fill_in "Title", with: @introduction.title
    click_on "Create Introduction"

    assert_text "Introduction was successfully created"
    click_on "Back"
  end

  test "updating a Introduction" do
    visit introductions_url
    click_on "Edit", match: :first

    fill_in "Description", with: @introduction.description
    fill_in "Intro index", with: @introduction.intro_index
    fill_in "Title", with: @introduction.title
    click_on "Update Introduction"

    assert_text "Introduction was successfully updated"
    click_on "Back"
  end

  test "destroying a Introduction" do
    visit introductions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Introduction was successfully destroyed"
  end
end
