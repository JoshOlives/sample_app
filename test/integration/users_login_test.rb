require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:vanessa)
    @other_user = users(:archer)
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
    #Simulate a user clicking a logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", user_path(@user), false
    assert_select "a[href=?]", logout_path, count: 0
  end
  
  test 'check if cookies then no cookies' do
    log_in_as(@user)
    assert_not cookies['remember_token'].nil?
    assert_equal cookies['remember_token'], assigns(:user).remember_token                                        
                                              # why is there no remember_token
                                              #attribute but there is a cookie
    #log in without checkmarks              maybe cant access test user attributes
    log_in_as(@user, remember_me: '0')      # cause its a virtual attribute
    assert cookies['remember_token'].empty? #deleted not set to nil
  end            
  # need to put key as key instead of symbol cause its in a test

  test 'logging in another tab and tring to log in another that hasnt updated' do
    log_in_as(@user, remember_me: '0')
    assert_redirected_to @user
    assert cookies['remember_token'].nil?
    log_in_as(@user,password: '', remember_me: '1')
    assert_not cookies['remember_token'].empty?
    assert_redirected_to @user
    log_in_as(@user,password: '', remember_me: '0')
    assert cookies['remember_token'].empty?
    log_in_as(@other_user, remember_me: '1')
    assert_not flash.nil?
    #nont really the best way cause they could have someone else's cookies
    assert cookies['remember_token'].empty?
    assert_redirected_to root_path
  end
end
