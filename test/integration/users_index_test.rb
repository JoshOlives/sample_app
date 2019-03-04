require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:vanessa)
    @other_user = users(:archer)
    @admin = users(:lana)
    @unactivated = users(:malory)
  end

  test "index including pagination" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1, per_page: 15).each do |u|
      if !u.activated?
        assert_select 'a[href=?]', user_path(u), count: 0
      else
        assert_select 'a[href=?]', user_path(u), text: u.name
      end
      unless u == @admin || !u.activated?
        assert_select 'a[href=?]', user_path(u), text: 'delete'
      end
    end
  end
  
  test 'succesful deletion' do
    log_in_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_path
    follow_redirect!
    assert_not flash.nil? 
    assert_template 'users/index'
  end
  
  #a for link?? yes
  test 'index as non-admin' do
    log_in_as(@user)
    get users_path
    #tests for no link saying delete
    #doesnt necessarily prevent a 'delete' link
    assert_select 'a', text: 'delete', count: 0
  end
  
  test 'cant access unactivate user prof page' do
    log_in_as(@user)
    get user_path(@unactivated)
    assert_redirected_to root_path
    follow_redirect!
    assert flash.empty?
    assert_template 'static_pages/home'
  end
end