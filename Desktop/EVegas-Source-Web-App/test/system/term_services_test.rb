require "application_system_test_case"

class TermServicesTest < ApplicationSystemTestCase
  setup do
    @term_service = term_services(:one)
  end

  test "visiting the index" do
    visit term_services_url
    assert_selector "h1", text: "Term Services"
  end

  test "creating a Term service" do
    visit term_services_url
    click_on "New Term Service"

    fill_in "Content", with: @term_service.content
    fill_in "Index", with: @term_service.index
    fill_in "Name", with: @term_service.name
    click_on "Create Term service"

    assert_text "Term service was successfully created"
    click_on "Back"
  end

  test "updating a Term service" do
    visit term_services_url
    click_on "Edit", match: :first

    fill_in "Content", with: @term_service.content
    fill_in "Index", with: @term_service.index
    fill_in "Name", with: @term_service.name
    click_on "Update Term service"

    assert_text "Term service was successfully updated"
    click_on "Back"
  end

  test "destroying a Term service" do
    visit term_services_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Term service was successfully destroyed"
  end
end
