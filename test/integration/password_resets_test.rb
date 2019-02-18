require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
     #what does this mean?
    ActionMailer::Base.deliveries.clear
    @user = users(:vanessa)
  end
  
  test 'password reset' do
    get new_password_reset_path
    #invalid email for password reset
    post password_resets_path, params: {reset: {email: "fake@example.com" }}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #valid email
    post password_resets_path, params: {reset: {email: @user.email }}
    #how does this work????? doesnt update automatically save??
    #maybe not in tests?
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_not flash.empty?
    assert_redirected_to root_path
    assert_equal 1, ActionMailer::Base.deliveries.size #go over this
    #password reset form
    user = assigns(:user) #go more in depth with this
    #wrong email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_not flash.empty?
    assert_redirected_to root_path
    #inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_not flash.empty?
    assert_redirected_to root_path
    user.toggle!(:activated)
    #right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_not flash.empty?
    assert_redirected_to root_path
    #right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    #go over below
    #changed it to id from name cause extra [] where fucking things up. why tho?
    assert_select "input[id=user_fuck][type=hidden][value=?]", user.email
    #empty password, test for blank password?
    patch password_reset_path(user.reset_token), params: { user: {
                                                    fuck: user.email,
                                                    password: '',
                                                    password_confirmation: ''}}
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation' #no flash
    #invalid password
    patch password_reset_path(user.reset_token), params: { user: {fuck: user.email,
                                                      password: 'dddsss',
                                                      password_confirmation: 'dddssd'}}
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation' #no flash
    #valid password
    patch password_reset_path(user.reset_token), params: { user: {fuck: user.email,
                                                              password: 'passwords',
                                                    password_confirmation: 'passwords'}}
    assert_nil user.reload.reset_digest
    assert_redirected_to(user)
    assert is_logged_in?
    follow_redirect!
    assert_select 'div.alert-success'
  end
  
  test 'expired token' do
    get new_password_reset_path
    post password_resets_path, params: {reset: {email: @user.email}}
    user = assigns(:user)
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to new_password_reset_path
    follow_redirect!
    assert_match(/expired/i, response.body) 
    patch password_reset_path(user.reset_token), params: { user:
                                              {fuck: user.email, password: 'passwords',
                                                    password_confirmation: 'passwords'}}
    assert_response :redirect
    assert_redirected_to new_password_reset_path
    follow_redirect! #what does the ! do?
    #i guess ruby infers that by doing an inequality time
    #that is an expiration test
    assert_match(/expired/i, response.body) #looks for expired in html body (case insensitive)
  end 
end
