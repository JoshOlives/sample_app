require 'test_helper'
#flash has a lag but the errors dont
class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:vanessa)
  end
  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    #invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: {content: "" }}
    end
    assert_select 'div#error_explanation'
    #valid submission
    content = "valid post"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: {content: content, picture: picture }}
    end
    assert @user.microposts.first.picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, CGI.unescapeHTML(response.body)
    #delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    #visit diff user and no links
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
  
  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", CGI.unescapeHTML(response.body)
    delete logout_path #need to logout cause of extra code i added
    #User with zero microposts
    other_user = users(:mallory) #created another cause malory is not actiavted
    log_in_as(other_user)
    get root_path
    assert_match "#{other_user.microposts.count} microposts", CGI.unescapeHTML(response.body)
    content = "a micropost test"
    other_user.microposts.create!(content: content)
    get root_path
    assert_match "#{other_user.microposts.count} micropost", CGI.unescapeHTML(response.body)
    assert_match content, CGI.unescapeHTML(response.body)
  end
end
