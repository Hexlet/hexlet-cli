require 'test_helper'

class Hexlet::TeacherCLITest < MiniTest::Test
  def setup
    @router = Hexlet::Router.new
  end

  def test_submit
    FakeFS do
      result = Hexlet::TeacherCLI.start ["init", "--verbose"]
      assert { result }
    end
  end

  def test_submit
    # api_key = "api_key"
    stub = stub_request(:post, @router.api_teacher_lessons_url).
      # with(:headers => {'X-Hexlet-Api-Key' => api_key}).
      to_return(:status => 201)

    FakeFS do
      folder = "super_lesson"
      FileUtils.mkdir(folder)
      result = Hexlet::TeacherCLI.start ["submit", folder, "--verbose"]
      assert { result }
    end

    assert_requested stub
  end
end
