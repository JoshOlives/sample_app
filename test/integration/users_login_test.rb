require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:vanessa)
  end
  test 'checking log in page' do
    get login_path
    assert_select 'form[action="/login"]'
    post login_path, params: {session: {email:"", password:""}}
    assert_template 'sessions/new'
    assert_select 'div.alert-danger'
    get login_path
    assert_select 'div.alert-danger', false
  end
  test 'successful log in followed by logout' do
    get login_path
    post login_path, params: {session: {email: @user.email, password: 'password'}}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, false
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", user_path(@user), false
    assert_select "a[href=?]", logout_path, count: 0
  end
end
