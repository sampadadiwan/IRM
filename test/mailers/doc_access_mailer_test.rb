require "test_helper"

class DocAccessMailerTest < ActionMailer::TestCase
  test "notify_access" do
    mail = DocAccessMailer.notify_access
    assert_equal "Notify access", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
