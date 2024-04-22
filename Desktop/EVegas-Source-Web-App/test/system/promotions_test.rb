require "application_system_test_case"

class PromotionsTest < ApplicationSystemTestCase
  setup do
    @promotion = promotions(:one)
  end

  test "visiting the index" do
    visit promotions_url
    assert_selector "h1", text: "Promotions"
  end

  test "creating a Promotion" do
    visit promotions_url
    click_on "New Promotion"

    fill_in "Attachment", with: @promotion.attachment_id
    fill_in "Day of month", with: @promotion.day_of_month
    fill_in "Day of season", with: @promotion.day_of_season
    fill_in "Day of week", with: @promotion.day_of_week
    fill_in "Game type", with: @promotion.game_type
    fill_in "Issue date", with: @promotion.issue_date
    fill_in "Name", with: @promotion.name
    fill_in "Prize", with: @promotion.prize
    fill_in "Promotion category", with: @promotion.promotion_category_id
    fill_in "Remark", with: @promotion.remark
    fill_in "Status", with: @promotion.status
    fill_in "Terms", with: @promotion.terms
    fill_in "Time", with: @promotion.time
    click_on "Create Promotion"

    assert_text "Promotion was successfully created"
    click_on "Back"
  end

  test "updating a Promotion" do
    visit promotions_url
    click_on "Edit", match: :first

    fill_in "Attachment", with: @promotion.attachment_id
    fill_in "Day of month", with: @promotion.day_of_month
    fill_in "Day of season", with: @promotion.day_of_season
    fill_in "Day of week", with: @promotion.day_of_week
    fill_in "Game type", with: @promotion.game_type
    fill_in "Issue date", with: @promotion.issue_date
    fill_in "Name", with: @promotion.name
    fill_in "Prize", with: @promotion.prize
    fill_in "Promotion category", with: @promotion.promotion_category_id
    fill_in "Remark", with: @promotion.remark
    fill_in "Status", with: @promotion.status
    fill_in "Terms", with: @promotion.terms
    fill_in "Time", with: @promotion.time
    click_on "Update Promotion"

    assert_text "Promotion was successfully updated"
    click_on "Back"
  end

  test "destroying a Promotion" do
    visit promotions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Promotion was successfully destroyed"
  end
end
