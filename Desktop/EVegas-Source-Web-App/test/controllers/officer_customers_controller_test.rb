require 'test_helper'

class OfficerCustomersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get officer_customers_index_url
    assert_response :success
  end

end
