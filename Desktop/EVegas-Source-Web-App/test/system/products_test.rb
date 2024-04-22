require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "creating a Product" do
    visit products_url
    click_on "New Product"

    fill_in "Attachment", with: @product.attachment_id
    fill_in "Base price", with: @product.base_price
    fill_in "Desc", with: @product.desc
    fill_in "Name", with: @product.name
    fill_in "Point price", with: @product.point_price
    fill_in "Price", with: @product.price
    fill_in "Product category", with: @product.product_category_id
    fill_in "Product type", with: @product.product_type
    fill_in "Qrcode", with: @product.qrcode
    fill_in "Sku", with: @product.sku
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "updating a Product" do
    visit products_url
    click_on "Edit", match: :first

    fill_in "Attachment", with: @product.attachment_id
    fill_in "Base price", with: @product.base_price
    fill_in "Desc", with: @product.desc
    fill_in "Name", with: @product.name
    fill_in "Point price", with: @product.point_price
    fill_in "Price", with: @product.price
    fill_in "Product category", with: @product.product_category_id
    fill_in "Product type", with: @product.product_type
    fill_in "Qrcode", with: @product.qrcode
    fill_in "Sku", with: @product.sku
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "destroying a Product" do
    visit products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product was successfully destroyed"
  end
end
