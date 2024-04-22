require 'test_helper'

class UserFirstLoginsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_first_login = user_first_logins(:one)
  end

  test "should get index" do
    get user_first_logins_url
    assert_response :success
  end

  test "should get new" do
    get new_user_first_login_url
    assert_response :success
  end

  test "should create user_first_login" do
    assert_difference('UserFirstLogin.count') do
      post user_first_logins_url, params: { user_first_login: {  } }
    end

    assert_redirected_to user_first_login_url(UserFirstLogin.last)
  end

  test "should show user_first_login" do
    get user_first_login_url(@user_first_login)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_first_login_url(@user_first_login)
    assert_response :success
  end

  test "should update user_first_login" do
    patch user_first_login_url(@user_first_login), params: { user_first_login: {  } }
    assert_redirected_to user_first_login_url(@user_first_login)
  end

  test "should destroy user_first_login" do
    assert_difference('UserFirstLogin.count', -1) do
      delete user_first_login_url(@user_first_login)
    end

    assert_redirected_to user_first_logins_url
  end
end
