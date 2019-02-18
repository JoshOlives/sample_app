require 'test_helper' #what does this do again? copies the code?

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:vanessa)
    #associations
    #build = new, create = create
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end
  
  test 'should be valid' do
    assert @micropost.valid?
  end
  
  test 'should have user_id' do
   @micropost.user_id = nil
   assert_not @micropost.valid?
  end
  
  test 'presence and length of micropost' do
    @micropost.content = ''
    assert_not @micropost.valid?
    @micropost.content = ' ' * 50
    assert_not @micropost.valid?
    @micropost.content = 's' * 141
    assert_not @micropost.valid?
  end
  
  test 'order should be most recent first' do
    #gets first one from test database (fixtures)
    assert_equal microposts(:most_recent), Micropost.first
  end
end
