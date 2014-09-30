ENV['TEST'] = 'true'

require 'bundler/setup'
Bundler.require

require 'minitest/unit'
require 'mocha/mini_test'

require 'webmock/minitest'

Wrong.config.color

class Minitest::Test
  include Wrong
end

Minitest.autorun
