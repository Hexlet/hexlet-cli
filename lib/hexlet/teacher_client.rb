module Hexlet
  class TeacherClient < BaseClient
    def submit(slug, file)
      url = @router.api_teacher_lessons_url
      @logger.debug url

      fd = ENV["TEST"] ? "a" : File.new(file, "rb") # FIXME

      attrs = {
        lesson: {
          slug: slug,
          "packs_attributes[]" => [
            {tarball: fd}
          ]
        }
      }

      RestClient.post url, attrs, headers do |response, request, result, &block|
        @logger.debug response
        201 == response.code
      end
    end
  end
end
