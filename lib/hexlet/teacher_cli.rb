module Hexlet
  class TeacherCLI < BaseCLI
    desc 'init LESSON_NAME', 'init lesson skeleton'
    def init(lesson_name)
      folder = "#{lesson_name}_lesson"
      FileUtils.mkdir(folder)
      template_folder = File.join(File.dirname(__FILE__), 'templates', 'lesson', '.')
      FileUtils.cp_r(template_folder, folder)

      puts(t 'lesson_folder_created', folder: folder)
      true
    end

    desc 'submit PATH_TO_LESSON', 'submit lesson'
    def submit(path)
      expanded_path = File.expand_path(path)
      lesson_folder = File.split(expanded_path)[1]
      parts = lesson_folder.split('_')

      if parts.last != 'lesson'
        puts(t 'wrong_lesson_folder')
        return false
      end

      slug = parts[0, parts.size - 1].join('_')

      filepath = generate_lesson_tarball(expanded_path)

      client = build_client
      result = client.submit slug, filepath

      if result
        puts(t :created)
        true
      else
        puts(t :error)
        false
      end
    end

    private

    def generate_lesson_tarball(path)
      dist_path = File.join(path, 'dist')
      exercise_tarball_path = File.join(dist_path, 'exercise.tar.gz')

      FileUtils.mkdir_p(dist_path)

      File.open(exercise_tarball_path, 'wb') do |fd|
        sgz = Zlib::GzipWriter.new(fd)

        Archive::Tar::Minitar::Output.open(sgz) do |stream|
          FileUtils.cd path do
            files = Rake::FileList.new('**/*') do |f|
              f.exclude(/node_modules/)
              f.exclude(/bower_components/)
              f.exclude(/dist/)
              f.exclude('.git')

              ignorefile_path = './.gitignore'
              if File.file?(ignorefile_path)
                patterns = File.read(ignorefile_path).split('\n')
                patterns.each do |pattern|
                  f.exclude pattern
                end
              end
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

    def build_client(key = config['hexlet_api_key'])
      Hexlet::TeacherClient.new key, logger: logger, host: options['host']
    end
  end
end

