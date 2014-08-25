require 'bundler/setup'
Bundler.require

Wrong.config.color

class Minitest::Test
  include Wrong
end

Minitest.autorun
