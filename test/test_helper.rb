require 'bundler/setup'
Bundler.require

require 'webmock/minitest'

Wrong.config.color

class Minitest::Test
  include Wrong
end

Minitest.autorun
