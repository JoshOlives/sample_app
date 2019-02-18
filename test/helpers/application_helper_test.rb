require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    #var available case its in application_helper?
    assert_equal full_title,         "Ruby on Rails Tutorial Sample App"
    assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Sample App"
    assert_equal full_title("Sign up"), "Sign up | Ruby on Rails Tutorial Sample App"
    #was this how i was supposed to do this exercise?
  end
end    