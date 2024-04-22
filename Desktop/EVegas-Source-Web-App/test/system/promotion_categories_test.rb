require "application_system_test_case"

class PromotionCategoriesTest < ApplicationSystemTestCase
  setup do
    @promotion_category = promotion_categories(:one)
  end

  test "visiting the index" do
    visit promotion_categories_url
    assert_selector "h1", text: "Promotion Categories"
  end

  test "creating a Promotion category" do
    visit promotion_categories_url
    click_on "New Promotion Category"

    fill_in "Name", with: @promotion_category.name
    click_on "Create Promotion category"

    assert_text "Promotion category was successfully created"
    click_on "Back"
  end

  test "updating a Promotion category" do
    visit promotion_categories_url
    click_on "Edit", match: :first

    fill_in "Name", with: @promotion_category.name
    click_on "Update Promotion category"

    assert_text "Promotion category was successfully updated"
    click_on "Back"
  end

  test "destroying a Promotion category" do
    visit promotion_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Promotion category was successfully destroyed"
  end
end
