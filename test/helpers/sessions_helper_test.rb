require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
    def setup
        @user = users(:vanessa)
        remember @user
    end
    
    test 'testing remember branch of current_user when session is nil' do
        assert_equal current_user, @user #wrong order it is expected then actual
        assert is_logged_in?
    end
    
    test 'testing remember branch returns nil when digest is wrong' do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        assert_nil current_user
    end
end