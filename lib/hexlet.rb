require 'hexlet/version'

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
require 'childprocess'

I18n.available_locales = [:en]
I18n.enforce_available_locales = true
I18n.locale = :en

module Hexlet
  def self.root
    File.expand_path '../..', __FILE__
  end

  autoload 'Router', 'hexlet/router'

  autoload 'BaseClient', "#{root}/lib/hexlet/base_client"
  autoload 'TeacherClient', "#{root}/lib/hexlet/teacher_client"
  autoload 'MemberClient', "#{root}/lib/hexlet/member_client"

  autoload 'BaseCLI', "#{root}/lib/hexlet/base_cli"
  autoload 'MemberCLI', "#{root}/lib/hexlet/member_cli"
  autoload 'TeacherCLI', "#{root}/lib/hexlet/teacher_cli"
end

I18n.load_path = Dir[File.join(Hexlet.root, 'locales', '*.yml')]
I18n.backend.load_translations
I18n.t 'key' # FIXME: this is hack
