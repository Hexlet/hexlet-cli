require "hexlet/version"

require 'logger'
require 'yaml'
require 'fileutils'
require 'uri'
require 'zlib'
require 'open3'

require 'archive/tar/minitar'
require 'rake'
require 'thor'
require 'rest-client'
require 'i18n'

I18n.available_locales = [:en]
I18n.enforce_available_locales = true
I18n.locale = :en

I18n.load_path = Dir['locales/*.yml']
I18n.backend.load_translations
I18n.t "key" # FIXME this is hack

module Hexlet
  autoload "Router", "hexlet/router"

  autoload "BaseClient", "hexlet/base_client"
  autoload "TeacherClient", "hexlet/teacher_client"
  autoload "MemberClient", "hexlet/member_client"

  autoload "BaseCLI", "hexlet/base_cli"
  autoload "MemberCLI", "hexlet/member_cli"
  autoload "TeacherCLI", "hexlet/teacher_cli"

  # Your code goes here...
end
