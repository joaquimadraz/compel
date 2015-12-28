require 'simplecov'
SimpleCov.start

require 'compel'

require 'rack/test'
require 'support/sinatra_app'

def app
  SinatraApp
end

include Rack::Test::Methods
