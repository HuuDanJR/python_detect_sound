require "application_system_test_case"

class PyramidPointsTest < ApplicationSystemTestCase
  setup do
    @pyramid_point = pyramid_points(:one)
  end

  test "visiting the index" do
    visit pyramid_points_url
    assert_selector "h1", text: "Pyramid Points"
  end

  test "creating a Pyramid point" do
    visit pyramid_points_url
    click_on "New Pyramid Point"

    fill_in "Max point", with: @pyramid_point.max_point
    fill_in "Min point", with: @pyramid_point.min_point
    fill_in "Prize", with: @pyramid_point.prize
    click_on "Create Pyramid point"

    assert_text "Pyramid point was successfully created"
    click_on "Back"
  end

  test "updating a Pyramid point" do
    visit pyramid_points_url
    click_on "Edit", match: :first

    fill_in "Max point", with: @pyramid_point.max_point
    fill_in "Min point", with: @pyramid_point.min_point
    fill_in "Prize", with: @pyramid_point.prize
    click_on "Update Pyramid point"

    assert_text "Pyramid point was successfully updated"
    click_on "Back"
  end

  test "destroying a Pyramid point" do
    visit pyramid_points_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pyramid point was successfully destroyed"
  end
end
