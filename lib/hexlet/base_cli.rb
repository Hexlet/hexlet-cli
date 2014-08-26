module Hexlet
  class BaseCLI < Thor
    include Thor::Actions

    CONFIG_DIR = File.join(Dir.home, ".hexlet")
    CREDENTIALS_FILE = File.join(Dir.home, ".hexlet", "credentials")

    class_option :verbose, type: :boolean
    class_option :host, type: :string, default: "http://hexlet.io"

    desc "login HEXLET_API_KEY", "login on hexlet.io"
    def login(key)
      client = BaseClient.new key, logger: logger
      if client.login
        puts (t :ok)
        write_config("hexlet_api_key" => key)
      else
        puts (t :not_found)
      end
    end

    no_commands do
      def logger
        logger = Logger.new(STDOUT)
        logger.level = options[:verbose] ? Logger::DEBUG : Logger::INFO
        logger
      end

      def t key, options = {}
        command_name =  @_invocations.values.last.last
        ns = self.class.to_s.downcase.split("::").last
        I18n.t key, options.merge(scope: [ns, command_name])
      end

      def config
        if File.file?(CREDENTIALS_FILE)
          YAML.load_file(CREDENTIALS_FILE)
        else
          {}
        end
      end

      def write_config(data)
        FileUtils.mkdir_p(CONFIG_DIR)
        File.open(CREDENTIALS_FILE, 'w') do |f|
          f.write data.to_yaml
        end
        # TODO puts (I18n.t "update_config")
      end
    end
  end
end
