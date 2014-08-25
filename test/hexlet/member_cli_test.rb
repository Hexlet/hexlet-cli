require 'test_helper'

class Hexlet::MemberCLITest < MiniTest::Test
  def setup
    @router = Hexlet::Router.new
  end

  def test_login
    api_key = "api_key"
    config_file = File.join(Dir.home, ".hexlet", "credentials")

    stub = stub_request(:get, @router.api_member_user_check_url).
      to_return(:status => 200)

    FakeFS do
      result = Hexlet::MemberCLI.start ["login", api_key, "--verbose"]
      assert { result }
      assert { File.file?(config_file) }
    end

    assert_requested stub
  end
end
