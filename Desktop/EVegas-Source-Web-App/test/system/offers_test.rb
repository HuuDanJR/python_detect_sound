require "application_system_test_case"

class OffersTest < ApplicationSystemTestCase
  setup do
    @offer = offers(:one)
  end

  test "visiting the index" do
    visit offers_url
    assert_selector "h1", text: "Offers"
  end

  test "creating a Offer" do
    visit offers_url
    click_on "New Offer"

    fill_in "Description", with: @offer.description
    fill_in "Description cn", with: @offer.description_cn
    fill_in "Description kr", with: @offer.description_kr
    fill_in "Description vi", with: @offer.description_ja
    fill_in "Is highlight", with: @offer.is_highlight
    fill_in "Offer type", with: @offer.offer_type
    fill_in "Publish date", with: @offer.publish_date
    fill_in "Title", with: @offer.title
    fill_in "Title cn", with: @offer.title_cn
    fill_in "Title kr", with: @offer.title_kr
    fill_in "Title vi", with: @offer.title_ja
    fill_in "Url news", with: @offer.url_news
    click_on "Create Offer"

    assert_text "Offer was successfully created"
    click_on "Back"
  end

  test "updating a Offer" do
    visit offers_url
    click_on "Edit", match: :first

    fill_in "Description", with: @offer.description
    fill_in "Description cn", with: @offer.description_cn
    fill_in "Description kr", with: @offer.description_kr
    fill_in "Description vi", with: @offer.description_ja
    fill_in "Is highlight", with: @offer.is_highlight
    fill_in "Offer type", with: @offer.offer_type
    fill_in "Publish date", with: @offer.publish_date
    fill_in "Title", with: @offer.title
    fill_in "Title cn", with: @offer.title_cn
    fill_in "Title kr", with: @offer.title_kr
    fill_in "Title vi", with: @offer.title_ja
    fill_in "Url news", with: @offer.url_news
    click_on "Update Offer"

    assert_text "Offer was successfully updated"
    click_on "Back"
  end

  test "destroying a Offer" do
    visit offers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Offer was successfully destroyed"
  end
end
