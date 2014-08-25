module Hexlet
  class TeacherCLI < BaseCLI
    desc "submit PATH_TO_LESSON", "login on hexlet.io"
    def submit(path)
      lesson_folder = File.split(path)[1]
      parts = lesson_folder.split("_")

      if parts.last != "lesson"
        puts (t "wrong_lesson_folder")
        return false
      end

      slug = parts[0, parts.size - 2].join("_")
      locale = parts[-2]

      filepath = generate_lesson_tarball(path)

      result = client.submit slug, locale, filepath

      if result
        puts (t :created)
        true
      else
        puts (t :error)
        false
      end
    end

    private

    def generate_lesson_tarball(path)
      dist_path = File.join(path, "dist")
      exercise_tarball_path = File.join(dist_path, "exercise.tar.gz")

      FileUtils.mkdir_p(dist_path)

      File.open(exercise_tarball_path, 'wb') do |fd|
        sgz = Zlib::GzipWriter.new(fd)

        Archive::Tar::Minitar::Output.open(sgz) do |stream|
          FileUtils.cd path do
            files = Rake::FileList.new("**/*") do |f|
              f.exclude /node_modules/
              f.exclude /bower_components/
              f.exclude /dist/
              f.exclude ".git"
            end

            # raise files.inspect
            files.each do |entry|
              Archive::Tar::Minitar.pack_file(entry, stream)
            end
          end
        end
      end

      exercise_tarball_path
    end

    def client
      @client ||= Hexlet::TeacherClient.new config["hexlet_api_key"], logger: logger, host: options["host"]
    end
  end
end

