module Hexlet
  # FIXME add uri parser
  class Router
    def initialize(host = "http://hexlet.io")
      @host = host
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
