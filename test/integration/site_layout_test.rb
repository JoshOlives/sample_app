require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:vanessa)
    @static_paths_notlog = {root_path => 'static_pages/home', help_path => 'static_pages/help',
                     about_path => 'static_pages/about', contact_path => 'static_pages/contact',
                    login_path => 'sessions/new', signup_path => 'users/new' }
    @static_paths_log = {root_path => 'static_pages/home', help_path => 'static_pages/help',
                     about_path => 'static_pages/about', contact_path => 'static_pages/contact',
                    users_path => 'users/index', signup_path => 'users/new',
                    user_path(@user) => 'users/show', edit_user_path(@user) => 'users/edit'}
  end
  test "layout links when logged out" do
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
    @static_paths_notlog.each do |k,v|
      get k
      assert_template v
    end
    get contact_path
    assert_select "title", full_title("Contact")
    get signup_path
    assert_select "title", full_title("Sign up")
    
  end
  
  test 'layout links when logged in' do
    log_in_as @user
    @static_paths_log.each do |k,v|
      get k
      assert_template v
    end
  end
end
