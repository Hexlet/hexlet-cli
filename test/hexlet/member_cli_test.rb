require 'test_helper'

class Hexlet::MemberCLITest < MiniTest::Test
  def test_login
    api_key = "api_key"
    result = Hexlet::MemberCLI.start ["login", api_key, "--verbose"]
    assert { result }
  end
end
