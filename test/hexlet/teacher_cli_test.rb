require 'test_helper'

class Hexlet::TeacherCLITest < MiniTest::Test
  def setup
    @router = Hexlet::Router.new
  end

  def test_init
    FakeFS do
      FileUtils.mkdir_p("#{Hexlet.root}/lib/hexlet/templates/lesson")
      result = Hexlet::TeacherCLI.start ['init', 'lesson-name', '--verbose']
      assert { result }
    end
  end

  def test_submit
    # api_key = 'api_key'
    stub = stub_request(:post, @router.api_teacher_lessons_url)
      .to_return(status: 201)
    # with(:headers => {'X-Hexlet-Api-Key' => api_key}).

    FakeFS do
      folder = 'super_lesson'
      FileUtils.mkdir(folder)
      result = Hexlet::TeacherCLI.start ['submit', folder, '--verbose']
      assert { result }
    end

    assert_requested stub
  end
end
