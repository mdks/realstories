require 'test_helper'

class UserNotifierTest < ActionMailer::TestCase
  test "forgot_password" do
    @expected.subject = 'UserNotifier#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserNotifier.create_forgot_password(@expected.date).encoded
  end

end
