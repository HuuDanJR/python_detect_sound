require 'test_helper'

class OffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @offer = offers(:one)
  end

  test "should get index" do
    get offers_url
    assert_response :success
  end

  test "should get new" do
    get new_offer_url
    assert_response :success
  end

  test "should create offer" do
    assert_difference('Offer.count') do
      post offers_url, params: { offer: { description: @offer.description, description_cn: @offer.description_cn, description_kr: @offer.description_kr, description_ja: @offer.description_ja, is_highlight: @offer.is_highlight, offer_type: @offer.offer_type, publish_date: @offer.publish_date, title: @offer.title, title_cn: @offer.title_cn, title_kr: @offer.title_kr, title_ja: @offer.title_ja, url_news: @offer.url_news } }
    end

    assert_redirected_to offer_url(Offer.last)
  end

  test "should show offer" do
    get offer_url(@offer)
    assert_response :success
  end

  test "should get edit" do
    get edit_offer_url(@offer)
    assert_response :success
  end

  test "should update offer" do
    patch offer_url(@offer), params: { offer: { description: @offer.description, description_cn: @offer.description_cn, description_kr: @offer.description_kr, description_ja: @offer.description_ja, is_highlight: @offer.is_highlight, offer_type: @offer.offer_type, publish_date: @offer.publish_date, title: @offer.title, title_cn: @offer.title_cn, title_kr: @offer.title_kr, title_ja: @offer.title_ja, url_news: @offer.url_news } }
    assert_redirected_to offer_url(@offer)
  end

  test "should destroy offer" do
    assert_difference('Offer.count', -1) do
      delete offer_url(@offer)
    end

    assert_redirected_to offers_url
  end
end
