require 'test_helper'

class TermServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @term_service = term_services(:one)
  end

  test "should get index" do
    get term_services_url
    assert_response :success
  end

  test "should get new" do
    get new_term_service_url
    assert_response :success
  end

  test "should create term_service" do
    assert_difference('TermService.count') do
      post term_services_url, params: { term_service: { content: @term_service.content, index: @term_service.index, name: @term_service.name } }
    end

    assert_redirected_to term_service_url(TermService.last)
  end

  test "should show term_service" do
    get term_service_url(@term_service)
    assert_response :success
  end

  test "should get edit" do
    get edit_term_service_url(@term_service)
    assert_response :success
  end

  test "should update term_service" do
    patch term_service_url(@term_service), params: { term_service: { content: @term_service.content, index: @term_service.index, name: @term_service.name } }
    assert_redirected_to term_service_url(@term_service)
  end

  test "should destroy term_service" do
    assert_difference('TermService.count', -1) do
      delete term_service_url(@term_service)
    end

    assert_redirected_to term_services_url
  end
end
