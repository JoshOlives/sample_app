require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", 
    password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do   #WHAT WAS THE POINT OF THIS WHOLE THING?
    @user.name = "  "               # Ah i get it, use this to test all
    assert_not @user.valid?         #user models and make sure all scenarios
  end                               #pass the tests

test "email should be present" do   
    @user.email = " "
    assert_not @user.valid?        
  end 
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_a = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_a.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} is not valid"
    end
  end
  
  test "email should include all symbols" do
    invalid_a = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_a.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should not be valid"
    end
  end
  
  test "email adresses should be unique" do
    dup = @user.dup
    dup.email = @user.email.upcase
    @user.save
    assert_not dup.valid?
  end
  
  test "email addresses should be saves as lower-case" do
    mixed = "fOo@bAr.com"
    @user.email = mixed
    @user.save
    assert_equal @user.reload.email, mixed.downcase #isnt reload unesecessary?
  end
  
  test "testing reload" do
    @user.save
    mixed = "fOo@bAr.com"
    @user.email = mixed
    assert_not (@user.reload.email == mixed) #isnt reload unesecessary?
  end
  
  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?, "password is blank"
  end
  
  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?, "password is too short"
  end
  
  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '') #doesnt matter what we put because error occurs before input is processed
  end
  
  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'lorem ipsum')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
