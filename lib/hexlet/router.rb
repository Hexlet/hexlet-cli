module Hexlet
  # FIXME add uri parser
  class Router
    def initialize(host = "http://hexlet.io")
      @host = host
    end

    def api_member_lesson_backend_results_url(lesson_slug, exercise_slug)
      generate("api_member/lessons/%s/backends/%s/results" % [lesson_slug, exercise_slug])
    end

    def api_member_lesson_backend_url(lesson_slug, exercise_slug)
      generate("api_member/lessons/%s/backends/%s" % [lesson_slug, exercise_slug])
    end

    def api_teacher_lessons_url
      generate("api_teacher/lessons")
    end

    def api_member_user_check_url
      generate("api_member/user/check_auth")
    end

    private

    def generate(url)
      URI("#{@host}/#{url}.json").to_s
    end
  end
end
