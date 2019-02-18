require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  
  def setup
    @user = users(:vanessa)
  end
  
  test 'checking pagination and microposts on prof page' do
    log_in_as(@user)
    get user_path(@user)
    @body = response.body
    assert_template 'users/show'
    assert_select 'div.pagination', count: 1
    #how to get count of microposts on first page?
    page_1 = @user.microposts.paginate(page: 1, per_page: 30) #count has 54 not 30?
    #assert_equal page_1.count, 30
    assert_select 'a[href=?]', user_path(@user), {count: 30, text: @user.name}
    assert_select 'a[href=?]', user_path(@user), count: 61 #plus 1 cause logged in
    assert_select 'title', full_title("#{@user.name}")
    assert_select 'h1', text: @user.name
    assert_select 'h3', "Microposts (#{@user.microposts.count.to_s})"
    #This checks for an img tag with class gravatar inside a top-level heading tag (h1).
    assert_select 'h1>img.gravatar'
    #check all the pages?
    #check for created at txt? in order?

    #WHY THE FUCK IS THIS NOT WORKING? 
    #PROBLEM WITH HIPSTER and not Escaping special  symbols like ' and @
    #specifically CGI.escapeHTML
    #CGI.unescapeHTML("test &quot;unescaping&quot; &lt;characters&gt;")
    assert_match Micropost.first.content, @body
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, CGI.unescapeHTML(@body)
      #assert @body.include?("#{micropost.content}")
    end
  end
end
