require 'test_helper'

class Hexlet::MemberCLITest < MiniTest::Test
  def setup
    @router = Hexlet::Router.new
  end

  def test_login
    # TODO use faker
    api_key = "api_key"
    config_file = File.join(Dir.home, ".hexlet", "credentials")

    stub = stub_request(:get, @router.api_member_user_check_url).
      with(:headers => {'X-Hexlet-Api-Key' => api_key}).
      to_return(:status => 200)

    FakeFS do
      result = Hexlet::MemberCLI.start ["login", api_key, "--verbose"]
      assert { result }
      assert { File.file?(config_file) }
    end

    assert_requested stub
  end

  def test_fetch
    stub = stub_request(:get, @router.api_member_lesson_backend_url("my_super", "exercise")).
      to_return(:status => 200)

    FakeFS do
      result = Hexlet::MemberCLI.start ["fetch", "my_super", "exercise", "--verbose"]
      assert { result }
    end

    assert_requested stub
  end

  def test_submit
    stub = stub_request(:post, @router.api_member_lesson_backend_results_url("my_super", "exercise")).
      to_return(:status => 201)
    Open3.stubs(:capture3).returns(["", "", 0])

    FakeFS do
      folder = "my_super_lesson/exercise"
      FileUtils.mkdir_p(folder)
      result = Hexlet::MemberCLI.start ["submit", folder, "--verbose"]
      assert { result }
    end

    assert_requested stub
  end
end
