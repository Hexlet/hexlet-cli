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
      slug = get_lesson_slug(path)

      client = build_client
      filepath = generate_lesson_tarball(expanded_path)
      result = client.submit slug, filepath

      if result
        puts(t :created)
        true
      else
        puts(t :error)
        false
      end
    end

    desc 'check_solution PATH', 'check solution'
    def check_solution(path)
      expanded_path = File.expand_path(path)
      backend_slug = expanded_path.split('/').last

      lesson_root = File.expand_path '../..', path
      lesson_slug = get_lesson_slug(lesson_root)

      Dir.mktmpdir do |dir|
        exercise_dir = "#{dir}/#{lesson_slug}_#{backend_slug}"
        Dir.mkdir(exercise_dir)

        FileUtils.cd path do
          files = Rake::FileList.new('**/*') do |f|
            ignorefile_path = './.gitignore'
            if File.file?(ignorefile_path)
              patterns = File.read(ignorefile_path).split("\n")
              patterns.each do |pattern|
                f.exclude pattern
              end
            end
          end
          FileUtils.cp_r(files, exercise_dir)
        end

        FileUtils.cd exercise_dir do
          r, w = IO.pipe

          process = ChildProcess.build('make', 'build')
          process.io.inherit!
          process.start
          process.wait

          process = ChildProcess.build('make', 'start')
          process.io.inherit!
          process.start
          process.wait

          # FIXME: wait supervisord will be loaded

          process = ChildProcess.build('make', 'test')
          process.io.stderr = w
          # process.io.inherit!
          process.start
          w.close

          begin
            process.poll_for_exit(100)
            if process.exit_code != 0
              begin
                loop { print r.readpartial(8192) }
              rescue EOFError
              end
              return false
            end
          rescue ChildProcess::TimeoutError
            process.stop # tries increasingly harsher methods to kill the process.
            puts t('timeout_error')
            return false
          end

          puts t('solution_works')
          true
        end
      end
    end

    desc 'check_without_solution PATH', 'check without solution'
    def check_without_solution(path)

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
                patterns = File.read(ignorefile_path).split("\n")
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

    no_commands do
      def get_lesson_slug(path)
        expanded_path = File.expand_path(path)
        lesson_folder = File.split(expanded_path)[1]
        parts = lesson_folder.split('_')

        if parts.last != 'lesson'
          raise t('wrong_lesson_folder')
        end
        parts[0, parts.size - 1].join('_')
      end
    end
  end
end

