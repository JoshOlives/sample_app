require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:vanessa)
    @other_user = users(:archer)
    @admin = users(:lana)
  end
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test 'redirect edit and update when not logged in' do
    get edit_user_path(@user)
    assert_redirected_to login_path
    assert_not flash.empty?
    patch user_path(@user), params: {user: { name: @user.name,
                                          email: @user.email}}
    assert_redirected_to login_path
    assert_not flash.empty?
    follow_redirect!
  end
  
  test 'redirect to root when logged it' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_redirected_to root_path
    assert_not flash.empty?
    patch user_path(@user), params: {user: { name: @user.name,
                                          email: @user.email}}
    assert_redirected_to root_path
    assert_not flash.empty?
    follow_redirect!
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should redirect index when logged in" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
  end
  
  test 'should not be able to become admin via web' do
    log_in_as(@user)
    assert_not @user.admin?
    #updating user
    patch user_path(@user), params: {
                                    user: { password:   'foobar',
                                            password_confirmation: 'foobar',
                                            admin: true } }
    assert_not @user.reload.admin?
  end
  
  test 'delete logged in but not admin' do
    log_in_as(@user)
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to users_path
    follow_redirect!
    assert_not flash.nil? # isnt nil till next action
    assert_template 'users/index'
  end
  
  test 'delete but not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to login_path
    follow_redirect!
    assert_not flash.nil? # isnt nil till next action
    assert_template 'sessions/new'
  end
end
