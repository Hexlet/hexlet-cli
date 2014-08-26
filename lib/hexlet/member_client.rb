module Hexlet
  class MemberClient < BaseClient
    def submit(lesson_slug, exercise_slug)
      url = @router.api_member_lesson_backend_results_url(lesson_slug, exercise_slug)
      @logger.debug url

      RestClient.post url, {}, headers do |response, request, result, &block|
        @logger.debug response
        201 == response.code
      end
    end
    def fetch(lesson_slug, exercise_slug)
      url = @router.api_member_lesson_backend_url(lesson_slug, exercise_slug)
      @logger.debug url

      RestClient.get url, headers do |response, request, result, &block|
        @logger.debug response
        if 200 == response.code
          response.body
        else
          false
        end
      end
    end
  end
end
