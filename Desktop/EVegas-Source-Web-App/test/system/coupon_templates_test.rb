require "application_system_test_case"

class CouponTemplatesTest < ApplicationSystemTestCase
  setup do
    @coupon_template = coupon_templates(:one)
  end

  test "visiting the index" do
    visit coupon_templates_url
    assert_selector "h1", text: "Coupon Templates"
  end

  test "creating a Coupon template" do
    visit coupon_templates_url
    click_on "New Coupon Template"

    fill_in "Benefit ids", with: @coupon_template.benefit_ids
    fill_in "Description", with: @coupon_template.description
    fill_in "Name", with: @coupon_template.name
    click_on "Create Coupon template"

    assert_text "Coupon template was successfully created"
    click_on "Back"
  end

  test "updating a Coupon template" do
    visit coupon_templates_url
    click_on "Edit", match: :first

    fill_in "Benefit ids", with: @coupon_template.benefit_ids
    fill_in "Description", with: @coupon_template.description
    fill_in "Name", with: @coupon_template.name
    click_on "Update Coupon template"

    assert_text "Coupon template was successfully updated"
    click_on "Back"
  end

  test "destroying a Coupon template" do
    visit coupon_templates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Coupon template was successfully destroyed"
  end
end
