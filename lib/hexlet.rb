require "hexlet/version"

require 'logger'
require 'yaml'
require 'fileutils'

require 'thor'
require 'rest-client'
require 'i18n'

I18n.available_locales = [:en]
I18n.enforce_available_locales = true
I18n.locale = :en

I18n.load_path = Dir['locales/*.yml']
I18n.backend.load_translations

module Hexlet
  autoload "BaseClient", "hexlet/base_client"
  # autoload "Client", "hexlet/base_client"

  autoload "BaseCLI", "hexlet/base_cli"
  autoload "MemberCLI", "hexlet/member_cli"
  autoload "TeacherCLI", "hexlet/teacher_cli"

  # Your code goes here...
end
