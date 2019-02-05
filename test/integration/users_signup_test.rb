require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    #what do the two colons mean again?
    ActionMailer::Base.deliveries.clear
  end
  test "invalid signup information" do
    get signup_path
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "", email: "", password: "",
                                        password_confirmation: ""}}
                                        #80% comprehension of these lines
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {user: { name: "Example User",
                                      email: "user@example.com", 
                                      password: "password",
                                      password_confirmation: "password"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #Logging in before activation
    log_in_as(user)
    assert_not is_logged_in?
    #invalid act token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    assert_not user.activated?
    #valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    assert_not user.activated?
    #valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert is_logged_in?
    assert user.reload.activated?
    assert_not user.activated_at.nil?
    #assert_redirected_to @user need fixture
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'
  end
end
