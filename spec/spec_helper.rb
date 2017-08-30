$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'similatron'

RSpec.configure do |config|
  config.before :suite do
    FileUtils.rm_r("tmp/")
  end
end
