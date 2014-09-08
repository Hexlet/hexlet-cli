module Hexlet
  class MemberCLI < BaseCLI
    desc "submit PATH_TO_EXERCISE", "submit exercise"
    def submit(path)
      expanded_path = File.expand_path(path)
      lesson_path, exercise_folder_name = File.split(expanded_path)
      lesson_folder_name = File.split(lesson_path)[1]
      parts = lesson_folder_name.split("_")

      if parts[-1] != "lesson"
        puts (t "wrong_lesson_folder")
        return false
      end

      lesson_slug = parts[0, parts.size - 1].join("_")

      # process = ChildProcess.build("make", "test")
      # process.start
      _, e, s = Open3.capture3("make test -C #{path}")
      if s == 0
        client = build_client
        result = client.submit lesson_slug, exercise_folder_name
        if result
          puts (t :created)
          true
        else
          puts (t :error)
          false
        end
      else
        puts (t :bad_tests)
        puts e
        false
      end
    end

    desc "fetch LESSON_SLUG EXERCISE_SLUG", "download lesson exercise"
    def fetch(lesson_slug, exercise_slug)
      # FIXME check login
      client = build_client
      if content = client.fetch(lesson_slug, exercise_slug)
        lesson_path = File.join("/", "vagrant", "exercises", "#{lesson_slug}_lesson")
        exercise_path = File.join(lesson_path, exercise_slug)
        if Dir.exists?(exercise_path)
          unless yes?(t "ask.replace_exercise")
            return true
          end
        end

        FileUtils.mkdir_p(exercise_path)

        tarball_path = File.join(exercise_path, "exercise.tar.gz")
        File.open(tarball_path, "w") do |f|
          f.write content
        end

        unless ENV['TEST'] # FIXME
          tgz = Zlib::GzipReader.new(File.open(tarball_path, 'rb'))
          Archive::Tar::Minitar.unpack(tgz, exercise_path)
        end

        puts (t :ok)
        true
      else
        puts (t :not_found)
        false
      end
    end

    private

    def build_client(key = config["hexlet_api_key"])
      Hexlet::MemberClient.new key, logger: logger, host: options["host"]
    end
  end
end
