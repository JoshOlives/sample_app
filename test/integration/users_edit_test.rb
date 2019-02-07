require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:vanessa)
    @other_user = users(:archer)
    @static_paths = [root_path, help_path, about_path, contact_path]
  end
 
  test 'invalid edit' do
    log_in_as(@user)
    get edit_user_path @user
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "", email: "", password: "",
                                    password_confirmation: ""}}
    assert_template 'users/edit'
    #diff between this and assert_template 'users/edit'??
    #assert_template cause its a render not redirect
  end
  
  test 'valid edit with friendly forwarding' do
    get edit_user_path(@user) # goes to log in
    assert_redirected_to login_path
    follow_redirect! #only need to follow for assert_select?
    assert_not session[:forwarding_url].nil?#AND assert_template
    #log in after restricted edit
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    follow_redirect!
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "pizza@gmail.com"
    #EDIT
    patch user_path(@user), params: {user: {name: name, email: email}}
    assert_redirected_to @user
    follow_redirect!
    assert_nil session[:forwarding_url]
    assert_not flash.empty?
    assert_template 'users/show'
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
    #does it truley allow empty?
    patch user_path(@user), params: {user: {name: 'm', email: email, password: "",
                                    password_confirmation: ""}}
    assert_redirected_to @user
    @user.reload
    assert_equal 'm', @user.name
    assert_equal @user.email, email
  end
  
  test 'store deletes after a redirect from login from restricted edit' do
    @static_paths.each do |f|
      get edit_user_path(@user)
      assert_redirected_to login_path
      follow_redirect! 
      assert_not session[:forwarding_url].nil?
      get f #doesnt test all the paths though after restricted edit
      get login_path #how to change that? irterating through a array/hash?
                    #it would have to be from the begining
      assert_nil session[:forwarding_url]
    end
  end
  
  #test 'goes to profile page if stored then log in to id != stored' do
   # get edit_user_path(@user) # goes to log in
   # assert_redirected_to login_path
   # follow_redirect! 
   # assert_not session[:forwarding_url].nil?
    #log in after restricted edit as other user
 #   log_in_as(@other_user)
 #   assert session[:forwarding_url].nil?
 #   assert_redirected_to @other_user
  #  assert flash.empty?
 # end
 
 test 'goes to profile page if stored then right edit to id != stored' do
  get edit_user_path(@user) # goes to log in
  assert_redirected_to login_path
  follow_redirect! 
  assert_not session[:forwarding_url].nil?
  log_in_as(@other_user)
  assert session[:forwarding_url].nil?
  assert_redirected_to edit_user_path @other_user
  assert flash.empty?
 end
end
