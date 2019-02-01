require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:vanessa)
    @other_user = users(:archer)
    @admin = users(:lana)
  end

  test "index including pagination" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1, per_page: 15).each do |u|
      assert_select 'a[href=?]', user_path(u), text: u.name
      unless u == @admin
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
    assert_select 'a', text: 'delete', count: 0
  end
end